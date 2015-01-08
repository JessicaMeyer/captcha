require "pg"

require_relative "storymash/users_repo.rb"

module Storymash
  def self.create_db_connection(dbname)
    PG.connect(host: 'localhost', dbname: dbname)
  end

  def self.clear_db(db)
    db.exec <<-SQL
      DELETE FROM users;
      DELETE FROM sessions;
    SQL
  end

  def self.create_tables(db)
    db.exec <<-SQL
      CREATE TABLE IF NOT EXISTS users(
        id SERIAL PRIMARY KEY,
        username VARCHAR,
        password VARCHAR
      );
      CREATE TABLE IF NOT EXISTS sessions(
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users (id),
        token TEXT UNIQUE
      );
    SQL
  end

  def self.seed_db(db)
    sql = %q[
      INSERT INTO users (username, password) values ($1, $2)
    ]
    db.exec(sql, ['Larry', 'pass123'])
    db.exec(sql, ['Curly', 'go456'])
    db.exec(sql, ['Moe', 'collect200'])
  end

  def self.drop_tables(db)
    db.exec <<-SQL
      DROP TABLE users;
      DROP TABLE sessions;
    SQL
  end

# End Storymash Module
end
