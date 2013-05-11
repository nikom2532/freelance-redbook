require 'spec_helper'

describe Staff do
  it "should always have a role" do
    staff = Staff.new
    staff.save.should == false
    staff[:role] = "Mod"
    staff.save.should == false
    staff.group = Group.new
    staff.save.should == true
  end
end
