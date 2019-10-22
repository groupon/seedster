#
# EXAMPLE APP:
#
# https://github.com/andyatkinson/rails-with-seedster
#
Seedster.configure do |c|

  # NOTE: Configured to dump and load from localhost by default,
  # however more typically, the dump host would be Production, and
  # the load host would be the Development environment
  #
  #

  # DATABASE configuration
  config   = Rails.configuration.database_configuration
  environment = "development"

  c.dump_host     = config[environment]["host"]
  c.dump_database = config[environment]["database"]
  c.dump_username = config[environment]["username"]
  c.dump_password = config[environment]["password"]

  c.load_host     = config[environment]["host"]
  c.load_database = config[environment]["database"]
  c.load_username = config[environment]["username"]
  c.load_password = config[environment]["password"]

  # pass in values to substitute into queries,
  # e.g. Run `rake seedster:dump USER_ID=1` to dump
  # all data for User 1
  c.query_params = { user_id: ENV['USER_ID'] }

  # SEEDSTER options
  #
  # Use this option if you are provided a dump file,
  # and expect to load data from the local dump file
  #
  # A dump file named this, will be extracted and loaded.
  # `tmp/data_dumps/seedster-dump-latest.tar.gz`
  #
  c.skip_download = false

  # Set this option to true if you want to disable table triggers, e.g. foreign key constraints
  c.disable_db_triggers = false

  # REMOTE data dump download options
  # NOTE: These options are ignored if `skip_download` is true
  #
  c.ssh_host = 'prod.host.com'
  c.ssh_user = 'ssh_user' # which user will connect to the host
  c.remote_host_path = "/var/company/www/app/current" # where the root of the app is deployed on the host

  #
  # Help:
  # Array of hashes with keys `query` and `name`, one per table
  #
  # Keys:
  # query: the SQL query for the table to be dumped. Add a parameter like `user_id` to be passed in.
  # name: the name of the database table
  #
  c.tables = [

    # {
    #   query: %{SELECT * FROM users WHERE id = '%{user_id}'},
    #   name: 'users'
    # },
    # {
    #   query: %{SELECT p.* FROM posts p JOIN users u ON p.user_id = u.id WHERE u.id = '%{user_id}'},
    #   name: 'posts'
    # },
    # {
    #   query: %{SELECT c.* FROM comments c JOIN users u ON c.user_id = u.id WHERE u.id = '%{user_id}'},
    #   name: 'comments'
    # }

  ]
end
