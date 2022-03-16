# frozen_string_literal: true

require 'yaml'

db_config = YAML.safe_load_file('config/database.yml')
db_config['host']     = ENV['DB_HOST'] if ENV['DB_HOST']
db_config['database'] = ENV['DB_NAME'] if ENV['DB_NAME']
db_config['username'] = ENV['DB_USER'] if ENV['DB_USER']
db_config['password'] = ENV['DB_PASS'] if ENV['DB_PASS']

DB = Sequel.connect(db_config)
