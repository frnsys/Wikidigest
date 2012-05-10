class WordLink < ActiveRecord::Base
	belongs_to :node
	belongs_to :word	
end
