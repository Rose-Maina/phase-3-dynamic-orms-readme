require 'sqlite3'

#Creating the database, 
DB = {:conn => SQLite3::Database.new("db/songs.db")}

#Droppig songs to avoid an error.
DB[:conn].execute("DROP TABLE IF EXISTS songs")

#Creating the songs table.
sql = <<-SQL
  CREATE TABLE IF NOT EXISTS songs (
  id INTEGER PRIMARY KEY,
  name TEXT,
  album TEXT
  )
SQL

DB[:conn].execute(sql)
#Using the results_as_hash method availed by the SQLite3-Ruby gem. 
#This method says: when a SELECT statement is executed, don't return a database row as an array, 
#return it as a hash with the column names as keys.

DB[:conn].results_as_hash = true
