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
    attr_accessor :dump_host, :dump_database,
      :dump_username, :dump_password,
      :load_host, :load_database,
      :load_username, :load_password,
      :remote_host_path,
      :query_params,
      :ssh_user,
      :ssh_host,
      :tables,
      :skip_download

    def initialize
      @dump_host = nil
      @dump_database = nil
      @dump_username = nil
      @dump_password = nil
      @load_host = nil
      @load_database = nil
      @load_username = nil
      @load_password = nil
      @remote_host_path = nil
      @query_params = {}
      @ssh_user = nil
      @ssh_host= nil
      @tables = []
      @skip_download = false
    end
  end
end
