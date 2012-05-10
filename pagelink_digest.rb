#!/user/bin/env ruby

require "rubygems"
require "active_record"
require "yaml"
require "mysql2"

=begin

Pagelink Dump Digester
****************************
Copyright 2012 Francis Tseng

Iterates through every entry of the imported pagelinks database and creates corresponding edge entries.

=end

# Connect to the database
dbconfig = YAML::load(File.open('../config/database.yml')) # load database config
ActiveRecord::Base.establish_connection(dbconfig['development']) # connect to (development) db

Pagelink.find(:all, :limit => 5).reverse.each do |pagelink|
	if pagelink.pl_namespace == 0
		Edge.create(:node_a_id => pagelink.pl_from, :node_b_id => Node.find_by_title(pagelink.gsub!(/_/," ")).page_id, :weight => 0.0)
	end
end
