# it should contain minimal code to setup the database connection, without loading any models

require 'sequel'

DB = Sequel.connect(
  ENV.fetch('DATABASE_URL'),
  max_connections: 10,
  logger: Logger.new('log/db.log')
)
