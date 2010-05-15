#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Glyph::Macro do

	before do
		Glyph.macro :test do
			"Test: #{raw_value}"
		end
		create_tree = lambda {|text| }
		create_doc = lambda {|tree| }
		@text = "test[section[header[Test!|test]]]"
		@tree = create_tree @text 
		@doc = create_doc @tree
		@node = {:macro => :test, :value => "Testing...", :source => "--", :document => @doc}.to_node
		@macro = Glyph::Macro.new @node
	end

	it "should raise macro errors" do
		lambda { @macro.macro_error "Error!" }.should raise_error(Glyph::MacroError)
	end

	it "should interpret strings" do
		@macro.interpret("test[--]").should == "Test: --"
	end

	it "should not interpret escaped macros" do
		Glyph.macro :int_1 do
			"->#{interpret(value)}<-"
		end
		Glyph.macro :int_2 do
			"=>#{interpret(value)}<="
		end
		text1 = "int_1[int_2[Test]]"
		text2 = "int_1[=int_2[Test]=]"
		text3 = "int_1[=int_2\\[Test\\]=]"
		text4 = "int_2[int_1[=int_1[wrong_macro[Test]]=]]"
		@macro.interpret(text1).should == "->=>Test<=<-"
		@macro.interpret(text2).should == "->int_2\\[Test\\]<-"
		@macro.interpret(text3).should == "->int_2\\[Test\\]<-"
		@macro.interpret(text4).should == "=>->int_1\\[wrong_macro\\[Test\\]\\]<-<="
	end

	it "should store and check bookmarks" do
		h = { :id => "test2", :title => "Test 2" }
		@macro.bookmark h
		@doc.bookmark?(:test2).should == h
		@macro.bookmark?(:test2).should == h
	end

	it "should store and check headers" do
		h = { :level => 2, :id => "test3", :title => "Test 3" }
		@macro.header h
		@doc.header?("test3").should == h
		@macro.header?("test3").should == h
	end

	it "should store placeholders" do
		@macro.placeholder { |document| }
		@doc.placeholders.length.should == 1
	end

	it "should execute" do
		@macro.execute.should == "Test: Testing..."
	end

	it "should detect mutual inclusion" do
		delete_project
		create_project
		Glyph.run! 'load:macros'
		Glyph::SNIPPETS[:inc] = "Test &[inc]"
		lambda {interpret("&[inc] test").document}.should raise_error(Glyph::MutualInclusionError)
	end

	it "should encode and decode text" do
		Glyph.run! "load:all"
		Glyph.macro :sec_1 do
			res = decode "section[header[Test1]\n#{value}]"
			interpret res
		end
		Glyph.macro :sec_2 do
			encode "section[section[header[Test2]\n#{value}]]"
		end
		text1 = %{sec_1[sec_2[Test]]}
		interpret text1
		res1 = @p.document.output.gsub(/\t/, '')
		text2 = %{section[header[Test1]
			section[section[header[Test2]
			Test]]]}
		interpret text2
		res2 = @p.document.output.gsub(/\t/, '')
		result = "<div class=\"section\">
				<h2 id=\"h_1\">Test1</h2>
				<div class=\"section\">
					<div class=\"section\">
						<h4 id=\"h_2\">Test2</h4>
						Test

					</div>

				</div>

			</div>".gsub(/\t/, '')
		res1.should == result
		res2.should == result
	end

	it "should support a way to access parameters by name or position" do
		node = {:macro => :test, :value => "Testing...", :source => "--", :params => {}}.to_node
		node[:params][:test] = {:value => "test", :position => 1}
		macro = Glyph::Macro.new node
		macro.param(0).should == "test"
		macro.param(1).should == "Testing..."
		macro.param(:test).should == "test"
		macro.param("test").should == "test"
	end

end
