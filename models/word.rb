class Word < ActiveRecord::Base
	has_many :word_links
	has_many :nodes, :through => :word_links

	attr_accessible :name

end
