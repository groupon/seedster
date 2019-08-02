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
require 'seedster'

namespace :seedster do
  desc "Dump application seed data to a data dump file"
  task dump: :environment do
    puts "Seedster loading..."

    Seedster::DataDumper.new(
      dump_host: Seedster.configuration.dump_host,
      dump_database: Seedster.configuration.dump_database,
      dump_username: Seedster.configuration.dump_username,
      dump_password: Seedster.configuration.dump_password
    ).dump!
  end

  desc "Load application seed data from a remote dump file"
  task load: :environment do
    if !Rails.env.development?
      puts "Exiting. Seedster Data Load is intended for development only."
      return
    end

    Seedster::DataLoader.new(
      load_host: Seedster.configuration.load_host,
      load_database: Seedster.configuration.load_database,
      load_username: Seedster.configuration.load_username,
      load_password: Seedster.configuration.load_password,
      ssh_user: Seedster.configuration.ssh_user,
      ssh_host: Seedster.configuration.ssh_host,
      remote_host_path: Seedster.configuration.remote_host_path
    ).load!
  end
end

