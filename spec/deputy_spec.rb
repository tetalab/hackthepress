require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Deputy" do

  it "has cumul or not" do
    deputy = Deputy.new :nb_cumul => 1
    fail "should have cumul" if !deputy.is_cumul
    deputy.nb_cumul = 0
    fail "should not cumul" if deputy.is_cumul
  end

end
