#!/usr/bin/env ruby

macro "|xml|" do
	valid_xml_element
	max_parameters 1
	name = @node[:element]
	attributes # evaluate attributes
	xml_attributes = @node.children.select{|node| node.is_a?(Glyph::AttributeNode)}.
		map do |e| 
			if valid_xml_attribute(e[:name]) then
				%|#{e[:name]}="#{e[:value]}"|
			else
				nil
			end
		end.compact.join(" ")
	xml_attributes = " "+xml_attributes unless xml_attributes.blank?
	%{<#{name}#{xml_attributes}>#{param(0)}</#{name}>}
end
