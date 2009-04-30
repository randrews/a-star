require 'doublets.rb'

describe "Doublets solver" do
  before :all do
    puts "Doublets take a bit of time to solve; this spec may take a few minutes to run."
  end

  it "should solve things with method_missing" do
    Doublets.oil.gas.nil?.should==false
  end

  it "should exclude words properly" do
    Doublets.new(:exclude=>['gil']).oil.gas.include?('gil').should==false
  end
end
