require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "Account" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Account,'testuser'
    end

    it "should process Account query" do
      pending
    end

    it "should process Account create" do
      pending
    end

    it "should process Account update" do
      pending
    end

    it "should process Account delete" do
      pending
    end
  end  
end