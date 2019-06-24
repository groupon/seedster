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
      db_host: Seedster.configuration.db_host,
      db_name: Seedster.configuration.db_name,
      db_username: Seedster.configuration.db_username,
      db_password: Seedster.configuration.db_password
    ).dump!
  end

  desc "Load application seed data from a remote dump file"
  task load: :environment do
    return unless Rails.env.development? # only load in dev environment

    config = Rails.configuration.database_configuration
    Seedster::DataLoader.new(
      local_db_name: config['development']['database'],
      ssh_user: Seedster.configuration.ssh_user,
      ssh_host: Seedster.configuration.dump_host,
      remote_host_path: Seedster.configuration.remote_host_path
    ).load!
  end
end

