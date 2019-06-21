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
    attr_reader :ssh_user, :ssh_host, :local_db_name,
      :remote_host_path

    def initialize(ssh_user:, ssh_host:,
                   local_db_name:, remote_host_path:)
      @ssh_user = ssh_user
      @ssh_host = ssh_host
      @local_db_name = local_db_name
      @remote_host_path = remote_host_path
      print_greeting
      FileManager.create_seed_file_dir
    end

    def load!
      download_and_extract_file

      Seedster.configuration.tables.each do |item|
        load_data(table_name: item[:name])
      end
    end

    private

    def download_and_extract_file
      remote_host_path = Seedster.configuration.remote_host_path
      remote_file = "#{remote_host_path}/#{File.join(FileManager.dump_dir, FileManager.dump_file_name)}"
      scp_command = "scp -r #{ssh_user}@#{ssh_host}:#{remote_file} ."
      puts "Downloading file: #{scp_command}"
      system(scp_command)

      untar_command = "tar -zxvf #{FileManager.dump_file_name} -C #{FileManager.seed_file_dir}"
      puts "Extracting local file: #{untar_command}"
      system(untar_command)
    end

    def load_data(table_name:)
      filename = FileManager.get_filename(table_name: table_name)
      load_command = "COPY #{table_name} FROM '#{filename}' DELIMITERS ',' CSV"
      puts "loading '#{table_name}' from '#{filename}'"
      psql_cmd = %{psql -d '#{local_db_name}' -c "#{load_command}"}
      system(psql_cmd)
    end

    def print_greeting
      puts
      puts "🌱🌱🌱🌱🌱"
      puts "Hello from Seedster!"
      puts
      puts "Loading data requires a compatible schema version, and empty tables."
      puts "Before loading data locally, truncate the relevant tables (or you may see constraint errors)."
      puts "🌱🌱🌱🌱🌱"
      puts
    end
  end
end
