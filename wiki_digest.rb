#!/user/bin/env ruby

require "rubygems"
require "active_record"
require "yaml"
require "mysql2"
require "open-uri"
require "stringio"
require "ox"
require "sanitize"

require 'ruby-prof' 
require 'fileutils'

def print_profiler_results
	# ENABLE FOR PROFILING
	result = RubyProf.stop
  # Print a flat profile to text
  printer = RubyProf::FlatPrinter.new(result)
  printer.print(File.open('profiler/prof_flat.txt', 'w'), {:min_percent => 0, :print_file => true})
	printera = RubyProf::GraphPrinter.new(result)
  printera.print(File.open('profiler/prof_graph.txt', 'w'), {:min_percent => 0, :print_file => true})
	printerb = RubyProf::CallTreePrinter.new(result)
	printerb.print(File.open('profiler/prof_tree.txt', 'w'), {:min_percent => 0, :print_file => true})
	printerc = RubyProf::GraphHtmlPrinter.new(result)
	printerc.print(File.open('profiler/prof_graph.html', 'w'), {:min_percent => 0, :print_file => true})
end

dir = File.dirname(__FILE__)
Dir[dir+"/require/*.rb"].each {|file| require file }
Dir["/models/*.rb"].each {|file| require file }


=begin

Wikipedia Dump Digester
****************************
Copyright 2012 Francis Tseng

Digests a Wikipedia pages articles XML dump using a SAX parser. Each article is scrubbed, and then tf*idf is performed, summarizing each article into a descriptive word vector.

=end

RubyProf.start

# Connect to the database
dbconfig = YAML::load(File.open('config/database.yml')) # load database config
ActiveRecord::Base.establish_connection(dbconfig['development']) # connect to (development) db

# parse an XML
file = "wiki.xml"
io = open(file) # load XML into a IO stream
handler = Saxer.new()
Ox.sax_parse(handler, io) # SAX parsing

print_profiler_results

