#
# Copyright 2019 Groupon, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module Seedster
  class DataLoader
    attr_reader :ssh_user, :ssh_host, :remote_host_path,
      :load_host, :load_database, :load_username, :load_password,
      :file_manager, :disable_triggers

    def initialize(ssh_user:, ssh_host:, remote_host_path:, load_host:, load_database:,
                   load_username:, load_password:, disable_triggers: false)
      @ssh_user = ssh_user
      @ssh_host = ssh_host
      @remote_host_path = remote_host_path
      @load_host = load_host
      @load_database = load_database
      @load_username = load_username
      @load_password = load_password
      @file_manager = FileManager.new(app_root: Rails.root)
      @disable_triggers = disable_triggers
      print_greeting
    end

    def load!
      download_and_extract_file unless Seedster.configuration.skip_download

      if disable_triggers
        puts "***** Disabling triggers *****"
        Seedster.configuration.tables.each do |item|
          psql_cmd = "ALTER TABLE #{item[:name]} DISABLE TRIGGER ALL"
          system(psql_cmd_pattern % psql_cmd)
        end
      end

      Seedster.configuration.tables.each do |item|
        load_data(table_name: item[:name])
      end

      if disable_triggers
        puts "***** Enabling triggers *****"
        Seedster.configuration.tables.each do |item|
          psql_cmd = "ALTER TABLE #{item[:name]} ENABLE TRIGGER ALL"
          system(psql_cmd_pattern % psql_cmd)
        end
      end
    end

    private

    def psql_cmd_pattern
      %{PG_PASSWORD=#{load_password} psql --host #{load_host} --dbname #{load_database} --username #{load_username} -c "%s"}
    end

    def download_and_extract_file
      remote_host_path = Seedster.configuration.remote_host_path
      remote_file = "#{remote_host_path}/#{file_manager.consolidated_dump_file_name}"
      scp_command = "scp -r #{ssh_user}@#{ssh_host}:#{remote_file} ."
      puts "Downloading file: '#{scp_command}'"
      system(scp_command)

      untar_command = "tar -zxvf #{FileManager.dump_file_name} -C #{file_manager.seed_file_dir}"
      puts "Extracting file: '#{untar_command}'"
      system(untar_command)
    end

    def load_data(table_name:)
      filename = file_manager.get_filename(table_name: table_name)
      psql_load(filename: filename, table_name: table_name)
    end

    # TODO: this could be swapped out for MySQL equivalent by a motivated individual :)
    def psql_load(filename:, table_name:)
      load_command = "COPY #{table_name} FROM '#{filename}' DELIMITERS ',' CSV"
      puts "Loading '#{table_name}' from '#{filename}'"
      psql_cmd = psql_cmd_pattern % load_command
      system(psql_cmd)
    end

    def print_greeting
      puts
      puts "🌱🌱🌱🌱🌱"
      puts "SEEDSTER LOAD"
      puts "🌱🌱🌱🌱🌱"
      puts
      puts "`rake seedster:load` expects a compatible schema version and empty tables."
      puts "Run `rake db:reset` prior to running `rake seedster:load`"
      puts
      puts "Before loading data locally, truncate the relevant tables (or you may see constraint violation errors)."
      puts "Bugs and issues: https://github.com/groupon/seedster"
      puts "Thanks!"
      puts
    end
  end
end
