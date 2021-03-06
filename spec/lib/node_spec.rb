#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Node do

	def create_node
		@ht = {:a => 1, :b => 2}.to_node
	end

	it "should be a hash" do
		ht = Node.new
		ht.is_a?(Hash).should == true
		ht.children.should == []
	end

	it "should be generated from a hash" do
		create_node
		@ht.respond_to?(:children).should == true
	end

	it "should support child elements" do
		create_node
		lambda { @ht << "wrong" }.should raise_error
		lambda { @ht << {:c => 3, :d => 4} }.should_not raise_error
		@ht.children[0][:c].should == 3
		lambda { @ht << {:e => 5, :f => 6}.to_node }.should_not raise_error
		@ht.child(1) << {:g => 7, :h => 8}
		@ht.child(1) << {:i => 9, :j => 10}
		((@ht&1&1)[:j]).should == 10
		l = (@ht&1).length
		orphan = @ht&1&0
		orphan.parent.should == @ht&1
		(@ht&1).children.include?(orphan).should == true
		(@ht&1) >> orphan
		(@ht&1).children.length.should == l-1 
		orphan.parent.should == nil
		(@ht&1).children.include?(orphan).should == false
	end
	
	it "should support iteration" do
		create_node
		@ht << {:c => 3, :d => 4}
		@ht << {:e => 5, :f => 6}
		@ht.child(0) << {:g => 7, :h => 8}
		sum = 0
		@ht.each_child do |c|
			c.values.each { |v| sum+=v}
		end
		sum.should == 18
		level = 0
		str = ""
		@ht.descend do |c, l|
			level = l
			c.values.sort.each { |v| str+=v.to_s}
		end
		str.should == "12347856"
		level.should == 1
	end

	it "should store information about parent nodes" do
		create_node
		@ht << {:c => 3, :d => 4}
		@ht << {:e => 5, :f => 6}
		@ht.child(1) << {:g => 7, :h => 8}
		@ht.child(1).child(0) << {:i => 9, :j => 10}
		(@ht&1&0&0).parent.should == @ht&1&0
		(@ht&1&0&0).root.should == @ht
	end

	it "should find child nodes" do
		create_node
		@ht << {:c => 3, :d => 4}
		@ht << {:e => 5, :f => 6}
		result = @ht.find_child do |node|
			node[:d] == 4
		end
		result.to_hash.should == {:c => 3, :d => 4}
		result2 = @ht.find_child do |node|
			node[:q] == 7
		end
		result2.should == nil
	end

	it "should expose a dedicated inspect method" do
		create_node
		@ht << {:c => 3, :d => 4}
		@ht << {:e => 5, :f => 6}
		@ht.inspect.should == "#{@ht.to_hash.inspect}\n  #{(@ht&0).to_hash.inspect}\n  #{(@ht&1).to_hash.inspect}"
	end

	it "should be convertable into a hash" do
		create_node
		@ht.to_hash.should == {:a => 1, :b => 2}
		lambda { @ht.to_hash.children }.should raise_error
	end

	it "should check equality of children as well" do
		create_node
		@ht << {:c => 3, :d => 4}
		@ht << {:e => 5, :f => 6}
		@ht2 = {:a => 1, :b => 2}.to_node
		@ht2 << {:c => 3, :d => 4}
		@ht2 << {:e => 5, :f => 6}
		(@ht==@ht2).should == true
		(@ht&1)[:c] = 47
		(@ht==@ht2).should == false
	end

end
