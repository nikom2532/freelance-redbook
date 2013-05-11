require 'spec_helper'

describe Group do
    it "should always have a name" do
      group = Group.new
      group.save.should == false
      group[:name] = "World Domination"
      group.save.should == false
      group[:kind] = "World Domination"
      group.save.should == true
    end
    it "should have a nested relationship" do
      root   = Group.create          name: "Parent Group", kind: "Parent Kind"
      child1 = root.subgroups.create name: 'Child Group #1', kind: "Child Kind 1"
      child2 = Group.create          name: "Child Group #2", kind: "Child Kind 2"
      root.subgroups << child2

      root.subgroups.size.should == 2
      child1.parentgroups.should == root
      child2.parentgroups.should == root
    end
    it "should accept nested attributes for subgroups" do
      group = Group.new :name => "root", :kind => "root_kind" ,
        :subplans_attributes => {:name => "child" , :kind => "Child_kind"}
      group.save
      group.subgroups.size.should == 1
      group.subgroups.first.name.should == "child"
    end
    
    it "should remove link not delete subgroups" do
      root   = Group.create          name: "Parent Group", kind: "Parent Kind"
      child1 = Group.create          name: "Child Group #1", kind: "Child Kind 1"
      root.subgroups << child1
      child1.parentgroups = root
      root.subgroups.size.should == 1
      root.subgroups.first.should == child1
      child1.parentgroups.first.should == root
      
      root.subgroups.delete(child1)
      child1.parentgroups.delete(root)
      
      root.subgroups.size.should == 0
      child1.parentgroups.should == nil
      
      root.name.should == "Parent Group"
      child1.name.should == "Child Group #1"
    end  
    
    it "should has one parent group" do
      root   = Group.create          name: "Root Group", kind: "Root Kind"
      parent1 = Group.create          name: "Parent Group 1", kind: "Parent Kind"
      parent2 = Group.create          name: "Parent Group 2", kind: "Parent Kind"
      root.parentgroups = parent1
      root.parentgroups.name.should == "Parent Group 1"
      root.parentgroups = parent2
      root.parentgroups.name.should == "Parent Group 2"
    end
    
    it "should remove link not delete parentgroups" do
      root   = Group.create          name: "Root Group", kind: "Root Kind"
      parent = Group.create          name: "Parent Group", kind: "parent Kind"
      root.parentgroups = parent
      parent.subgroups << root
      root.parentgroups.should == parent
      parent.subgroups.first.should == root
      
      root.parentgroups = nil
      parent.subgroups.delete(root)
      
      root.parentgroups.should == nil
      parent.subgroups.size.should == 0
      
    end
    
end
