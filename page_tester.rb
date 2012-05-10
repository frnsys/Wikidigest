#!/usr/bin/env ruby

=begin

Testing and hunting for errors in the digested page dump.
Copyright 2012 Francis Tseng

=end


require 'tempfile'
require 'fileutils'

path = 'enwiki-latest-page.sql'
count = 0
File.open(path, 'r') do |file|
  file.each_line do |line|
		count += 1
		scanned = line.scan(/.{20}\)\(.{20}/)
		if !scanned.empty?
    	puts "Line " + count.to_s
			puts scanned
		end
  end
end

# the regex:
# removes entries where page_namespace!=0 or !=14 (i.e. it only keeps article and category pages), where page_counter=0, and where page_is_redirect=1
# gsub(/\([0-9]*,[^0]*,[^\)]*\),|\([0-9]*,[0-9]*,'[^']*','[^']*',0,[^\)]*\),|\([0-9]*,[0-9]*,'[^']*','[^']*',[0-9]*,1,[^\)]*\),/,"")
# note the version that's actually being used does not remove page_is_redirect=1 entries
