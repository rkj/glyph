#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Glyph do

	before do
		Glyph.enable 'project:create'
	end

	it "should initialize a rake app and tasks" do
		Glyph::APP.tasks.length.should > 0
	end

	it "should run rake tasks" do
		create_project_dir
		Glyph.run 'project:create', Glyph::PROJECT
		lambda { Glyph.run! 'project:create', Glyph::PROJECT }.should raise_error
		delete_project_dir
		create_project_dir
		lambda { Glyph.run! 'project:create', Glyph::PROJECT }.should_not raise_error
		delete_project_dir
	end

end