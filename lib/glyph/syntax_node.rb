module Glyph

	class SyntaxNode < Node

		def evaluate(context, options={:attrs => false, :params => false})
			case self[:type]
			when :macro then
				self[:value] = expand_macro(context)
			when :attribute then
				self[:value] = ""
				self.children.each {|c| self[:value] << c.evaluate(context) } if options[:attrs]
			when :parameter then
				self[:value] = ""
				self.children.each {|c| self[:value] << c.evaluate(context) } if options[:params]
			when :document then
				self[:value] = ""
				self.children.each {|c| self[:value] << c.evaluate(context) }
			end
			self[:value]
		end

		def parent_macro
			find_parent{|n| n[:type] == :macro}
		end

	end

	class DocumentNode < SyntaxNode

		def to_s
			""
		end

	end

	class MacroNode < SyntaxNode

		def to_s
			e = self[:escape] ? "=" : ""
			"#{self[:name]}["+e+attributes.join+parameters.join("|")+e+"]"
		end

		def parameters
			children.select{|n| n.is_a? ParameterNode }
		end

		def parameter(n)
			parameters[n]
		end

		def attributes
			children.select{|n| n.is_a? AttributeNode }
		end

		def attribute(name)
			attributes.select{|n| n[:name] == name}[0]
		end

		def expand_macro(context)
			set_xml_element	
			self.merge!({
				:source => context[:source], 
				:document => context[:document], 
				:info => context[:info],
				:value => ""
			})
			Glyph::Macro.new(self).expand
		end

		def set_xml_element
			known_macro = Glyph::MACROS.include? self[:name]
			name = self[:name].to_s
			element = nil
			if !known_macro && name.match(/^=(.+)/) then
				# Force tag name override if macro starts with a '='
				name.gsub! /^=(.+)/, '\1' 
			end
			case
				# Use XML syntax
			when Glyph['language.set'] == 'xml' then
				self[:element] = name
				self[:name] = :"|xml|" 
				# Fallback to XML syntax
			when Glyph['language.options.xml_fallback'] then
				unless known_macro then
					self[:element] = name
					self[:name] = :"|xml|" 
				end
			else
				# Unknown macro
				raise Glyph::RuntimeError, "Undefined macro '#{name}'\n -> source: #{current[:source]}" unless known_macro
			end
		end

	end

	class TextNode < SyntaxNode

		def to_s
			self[:value]
		end

	end

	class ParameterNode < SyntaxNode

		def to_s
			children.join
		end

	end

	class AttributeNode < SyntaxNode

		def to_s
			e = self[:escape] ? "=" : ""
			"@#{self[:name]}["+e+children.join+e+"]"
		end

	end

	class EscapeNode < SyntaxNode

		def to_s
			self[:value]
		end

	end

end
