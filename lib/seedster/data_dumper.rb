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
  class DataDumper
    attr_accessor :db_password
    attr_reader :db_host, :db_username, :db_name

    def initialize(db_password:, db_host:, db_username:, db_name:)
      @db_password = db_password
      @db_host = db_host
      @db_username = db_username
      @db_name = db_name
      FileManager.create_seed_file_dir
    end

    def dump!
      dump_tables
      create_consolidated_dump_file
    end

    private

    # Configuration parameters passed in via a hash here should be substituted into the query
    # Within the query, indicate a parameter to be replaced by using syntax like:
    #
    # %{user_id}
    #
    def dump_tables
      Seedster.configuration.tables.each do |item|
        full_query = item[:query] % Seedster.configuration.query_params
        sql_results_to_file(
          sql: full_query,
          table_name: item[:name]
        )
      end
    end

    def create_consolidated_dump_file
      dump_file = Rails.root.join(FileManager.dump_dir, FileManager.dump_file_name)
      puts "Creating dump file '#{dump_file}' from '#{FileManager.seed_file_dir}'"
      tar_command = "tar -zcvf #{dump_file} -C #{FileManager.seed_file_dir} ." # use relative paths
      system(tar_command) # use relative paths
    end

    def sql_results_to_file(sql:, table_name:)
      filename = FileManager.get_filename(table_name: table_name)
      puts "dumping '#{table_name}' to '#{filename}' with query '#{sql}'"
      psql_cmd = %{PGPASSWORD=#{db_password} psql -h #{db_host} -d #{db_name} -U #{db_username} -c "\\copy (#{sql}) TO '#{filename}' WITH CSV"}
      system(psql_cmd)
    end
  end
end
