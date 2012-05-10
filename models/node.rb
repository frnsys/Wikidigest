class Node < ActiveRecord::Base
	set_primary_key :page_id
	
	has_many :word_links
	has_many :words, :through => :word_links

	has_many :edges, :foreign_key => :node_a_id, :dependent => :destroy
	has_many :reverse_edges, :class_name => :Edge, :foreign_key => :node_b_id, :dependent => :destroy
	has_many :nodes, :through => :edges, :source => :node_b
	has_many :reverse_nodes, :through => :reverse_edges, :source => :node_a

	attr_accessible :page_id, :title
	
end
