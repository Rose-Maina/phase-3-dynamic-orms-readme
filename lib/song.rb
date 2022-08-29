require_relative "../config/environment.rb"
require 'active_support/inflector'

#Using the table_name method referenced by the self keyword, 
#for grabbing the table_name that will be used in querying for column names.
class Song
  def self.table_name
    self.to_s.downcase.pluralize
  end
  rue

  #PRAGMA  is used for returning column names as an array of hashes that describe the table itself
  # Every hash has info about one column
  # Here, the SQL statement uses the pragma keyword and the #table_name method for accessing the name of table being queried
  # An iteration over resulting array of hashes is done to collect only the name of every column. 
      sql = "pragma table_info('#{table_name}')"
  
      table_info = DB[:conn].execute(sql)
      column_names = []
      
  def self.column_names
    DB[:conn].results_as_hash = true

#PRAGMA  is used for returning column names as an array of hashes that describe the table itself
# Every hash has info about one column
# Here, the SQL statement uses the pragma keyword and the #table_name method to access the table name being queried
# An iteration over resulting array of hashes is done to collect only the name of every column. 
    sql = "pragma table_info('#{table_name}')"

    table_info = DB[:conn].execute(sql)
    column_names = []
    
    table_info.each do |row|
      column_names << row["name"]
    end
    
    column_names.compact
  end

#Iterating through the column names stored in the column_names class method
#The settting an attr_accessor for each column and convertig each to a symbol using the to_sym method.

  self.column_names.each do |col_name|
    attr_accessor col_name.to_sym
  end

  #Defining  the #initialize method to take in an argument of options
  #send method to interpolate the name of each hash key as a method that is equal to the key's value.
  def initialize(options={})
    options.each do |property, value|
      self.send("#{property}=", value)
    end
  end

  def save
    sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end

#Abstractig the table name
  def table_name_for_insert
    self.class.table_name
  end

#Abstracting the column names
  def values_for_insert
    values = []
    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end
    values.join(", ")
  end

  def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(", ")
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM #{self.table_name} WHERE name = '#{name}'"
    DB[:conn].execute(sql)
  end

end



