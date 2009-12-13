#!/usr/bin/env ruby
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require "stringio"

module Glyph; end

begin
	unless Glyph.const_defined? :TEST_MODE then
		Glyph::TEST_MODE = true
	end
rescue Exception => e
end

require "glyph"

Glyph.config_override :quiet, true

def create_project_dir
	Glyph::PROJECT.mkpath
end

def create_project
	create_project_dir
	Glyph.run! 'project:create', Glyph::PROJECT.to_s
end

def delete_project_dir
	Glyph::PROJECT.rmtree
end

alias delete_project delete_project_dir

def run_command(cmd)
	out = StringIO.new
	old_stdout = $stdout
	old_stderr = $stderr
	$stdout = out
	$stderr = out 
	GLI.run(cmd)
	$stdout = old_stdout
	$stderr = old_stderr
	out.string
end

def run_command_successfully(cmd)
	run_command(cmd).match(/error/) == nil
end

def create_sample_file(filename, text, opts={})
	contents = text
 	contents << '#{note "Test", :type => :important}\n' if opts[:tenjin]
	contents << '@test\n' if opts[:snippets]
	File.open((Glyph::PROJECT/"source"/filename).to_s, "w+") {|f| f.write contents }
end
