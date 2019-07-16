Seedster.configure do |c|
  c.db_host = 'host.com' # DB host. Fill this in, or reference Rails config/development.yml database values or ar-octopus config
  c.db_name = 'db_nameXXX'
  c.db_username = 'db_usernameXXX'
  c.db_password = 'passwordXXX'

  c.remote_host_path = "/var/company/www/app/current" # where the root of the app is deployed on the host

  c.query_params = { } # pass in values to interpolate into queries,
                       # e.g. USER_ID=XXX would be {user_id: ENV['USER_ID']}

  c.ssh_user = 'ssh_userXXX' # which user will connect to the host

  c.dump_host = 'app.host.com' # host where app is deployed

  #
  # Help:
  # Comma-separated list of hashes, with keys `query` and `name`, one hash per DB table
  #
  # Keys:
  # query: the SQL query for the table to be dumped. Add a parameter like `user_id` to be passed in.
  # name: the name of the database table
  #
  c.tables = [
    # BEGIN example ---
    # {
    #   query: %{SELECT u.* FROM users
    #       where u.id = '%{user_id}'},
    #   name: 'users'
    # }
    # END example -----
  ]
end
