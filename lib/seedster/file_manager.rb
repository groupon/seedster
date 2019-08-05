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
  class FileManager
    SEEDSTER = 'seedster'
    TMP_DIR = 'tmp'
    DATA_DUMPS_DIR = 'data_dumps'
    SEED_FILE_DIR = 'seedster_data_dumps'

    # Expects Pathname
    # https://ruby-doc.org/stdlib-2.5.1/libdoc/pathname/rdoc/Pathname.html
    attr_reader :app_root

    def initialize(app_root:)
      @app_root = app_root
    end

    def dump_dir
      # Capistrano note:
      # set up as a linked_dir in config/deploy.rb
      app_root.join(TMP_DIR, DATA_DUMPS_DIR)
    end

    def seed_file_dir
      app_root.join(TMP_DIR, SEED_FILE_DIR)
    end

    def get_filename(table_name:)
      File.join(seed_file_dir, "#{SEEDSTER}-#{table_name}.csv")
    end

    def create_dump_dir
      puts "Creating directory: '#{dump_dir}'"
      FileUtils.mkdir_p(dump_dir)
    end

    def create_seed_file_dir
      puts "Creating directory: '#{seed_file_dir}'"
      FileUtils.mkdir_p(seed_file_dir)
    end

    def consolidated_dump_file_name
      app_root.join(dump_dir, self.class.dump_file_name)
    end

    class << self
      def dump_file_name
        "#{SEEDSTER}-dump-latest.tar.gz"
      end
    end
  end
end
