#!/usr/bin/env ruby

=begin

Processes the page sql dump to remove extraneous entries.
Copyright 2012 Francis Tseng

=end


require 'tempfile'
require 'fileutils'

path = 'enwiki-latest-page.sql'
temp_file = Tempfile.new('temp')
File.open(path, 'r') do |file|
  file.each_line do |line|
    temp_file.puts line.gsub(/\([0-9]*,[^0|14]*,[^\)]*\),|\([0-9]*,[0-9]*,'[^']*','[^']*',[0-9]*,1,[^\)]*\),/,"")
  end
end
FileUtils.mv(temp_file.path, path)

# the regex:
# removes entries where page_namespace!=0 or !=14 (i.e. it only keeps article and category pages) and where page_is_redirect=1
# gsub(/\([0-9]*,[^0]*,[^\)]*\),|\([0-9]*,[0-9]*,'[^']*','[^']*',[0-9]*,1,[^\)]*\),/,"")
