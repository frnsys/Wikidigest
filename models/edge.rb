class Edge < ActiveRecord::Base
	belongs_to :node_a, :class_name => :Node
	belongs_to :node_b, :class_name => :Node	
end
