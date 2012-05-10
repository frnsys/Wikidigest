=begin

Extracts pagelinks and spawns edges from the Wikipedia articles dump.
Copyright 2012 Francis Tseng

=end

require "rubygems"
require "active_record"
require "yaml"
require "mysql2"
require "set"

class DBConn < ActiveRecord::Base
	dbconfig = YAML::load(File.open('../config/database.yml')) # load database config	
  establish_connection(dbconfig['development'])
end

# run this BEFORE wordify, otherwise the pagelinks get all scrambled.
def extract_pagelinks(text)
	pagelinks = text.scan(/(?<=\[\[)[^a-z*:|File:][^\]|#]*(?=\|)|(?<=\[\[)[^a-z*:|File:][^\]|#]*(?=\]\])/)
	pagelinks = pagelinks.uniq unless pagelinks.uniq.nil?
end	

def spawn_edges(node_id,pagelinks)
	pagelinks.each do |pagetitle|
		@page = DBConn.connection.select_all("SELECT * FROM page WHERE page_title=#{pagetitle.gsub(/\s/,"")} LIMIT 1")
		Edge.connection.execute "INSERT INTO edges (node_a_id,node_b_id,weight,created_at,updated_at) VALUES (#{node_id},#{@page[0]['page_id']},0,NOW(),NOW())"
		# note: for intialization, weight is set to 0. the weights will be calculated and updated as these edges are queried
	end
end

# regex for finding pagelink titles: mystring.scan(/(?<=\[\[)[^\]]*(?=\|)/)
# and mystring.scan(/(?<=\[\[)[^\]]*(?=\]\])/)
#
# mystring.scan(/(?<=\[\[)[^\]]*(?=\|)|(?<=\[\[)[^\]]*(?=\]\])/)

