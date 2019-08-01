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
require 'seedster/version'
require 'seedster/railtie' if defined?(Rails)
require 'seedster/file_manager'
require 'seedster/data_dumper'
require 'seedster/data_loader'

module Seedster
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :db_host, :db_name,
      :db_username, :db_password,
      :remote_host_path,
      :query_params,
      :ssh_user,
      :dump_host,
      :tables,
      :skip_download

    def initialize
      @db_host = nil
      @db_name = nil
      @db_username = nil
      @db_password = nil
      @remote_host_path = nil
      @query_params = {}
      @ssh_user = nil
      @dump_host = nil
      @tables = []
      @skip_download = false
    end
  end
end
