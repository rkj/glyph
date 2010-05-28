#!/usr/bin/env ruby
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require "stringio"

module Glyph; end

begin
	unless Glyph.const_defined? :MODE then
		Glyph::MODE = {:debug => false, :lite => false, :test => true} 
	end
rescue
end

require "glyph"

Glyph['system.quiet'] = true

def create_project_dir
	Glyph::PROJECT.mkpath
end

def reset_quiet
	Glyph.reset
	Glyph['system.quiet'] = true
end

def create_project
	reset_quiet
	create_project_dir
	return if Glyph.lite?
	Glyph.run! 'project:create', Glyph::PROJECT.to_s
	file_copy Glyph::SPEC_DIR/'files/container.textile', Glyph::PROJECT/'text/container.textile'
	(Glyph::PROJECT/'text/a/b/c').mkpath
	file_copy Glyph::SPEC_DIR/'files/included.textile', Glyph::PROJECT/'text/a//b/c/included.textile'
	file_copy Glyph::SPEC_DIR/'files/markdown.markdown', Glyph::PROJECT/'text/a//b/c/markdown.markdown'
	file_copy Glyph::SPEC_DIR/'files/document.glyph', Glyph::PROJECT/'document.glyph'
	file_copy Glyph::SPEC_DIR/'files/test.sass', Glyph::PROJECT/'styles/test.sass'
	file_copy Glyph::SPEC_DIR/'files/ligature.jpg', Glyph::PROJECT/'images/ligature.jpg'
end

def delete_project_dir
	return unless	Glyph::PROJECT.exist?
	Glyph::PROJECT.children.each do |f|
		FileUtils.rmtree f if f.directory? 
		FileUtils.rm f if f.file?
	end
end

def delete_project 
	delete_project_dir
	Glyph::SNIPPETS.clear
	Glyph::MACROS.clear
	Glyph['document.source'] = 'document.glyph'
	Glyph.document = nil
end

def run_command(cmd)
	out = StringIO.new
	old_stdout = $stdout
	old_stderr = $stderr
	$stdout = out
	$stderr = out 
	Glyph['system.quiet'] = false
	GLI.run cmd
	Glyph['system.quiet'] = true
	$stdout = old_stdout
	$stderr = old_stderr
	out.string
end

def run_command_successfully(cmd)
	run_command(cmd).match(/error/) == nil
end

def define_em_macro
	Glyph.macro :em do
		%{<em>#{value.to_s.strip}</em>}
	end
end

def define_ref_macro
	Glyph.macro :ref do
		%{<a href="#{parameter(0).to_s.strip}">#{parameter(1).to_s.strip}</a>}
	end
end

def language(set)
	reset_quiet
	Glyph.run 'load:config'
	Glyph['language.set'] = set
	Glyph.run 'load:macros'
end

def interpret(text)
	@p = Glyph::Interpreter.new(text)
end

def output_for(text)
	Glyph::Interpreter.new(text).document.output
end

def create_tree(text)
	Glyph::Interpreter.new(text).parse
end

def create_doc(tree)
	Glyph::Document.new tree, {} 
end

def filter(text)
	Glyph.filter text
end

def text_node(value, options={})
	Glyph::TextNode.new.from({:type => :text, :value => value}.merge options)
end

def escape_node(value, options={})
	Glyph::EscapeNode.new.from({:type => :escape, :value => value, :escaped => true})
end

def document_node
	Glyph::DocumentNode.new.from({:type => :document, :name => "--".to_sym})
end

def a_node(name, options={})
	Glyph::AttributeNode.new.from({
		:type => :attribute, 
		:name => :"#{name}", 
		:escape => false}.merge(options))
end

def p_node(n)
	Glyph::ParameterNode.new.from({:type => :parameter, :name => :"#{n}"})
end

def macro_node(name, options={})
	Glyph::MacroNode.new.from({
		:type => :macro, 
		:name => name.to_sym, 
		:escape => false
	}.merge options)
end
