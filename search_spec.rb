require 'rubygems'
require 'spec'

require 'a_star.rb'

describe "a-star" do

  before :all do
    @map={
      :houston=>[:san_marcos,:austin],
      :blacksburg=>[:houston,:sioux_falls],
      :sioux_falls=>[:houston,:boston],
      :austin=>[:san_antonio,:houston]
    }

    @map_neighbors=lambda do |city|
      @map[city]
    end
  end

  it "map_neighbors should work" do
    @map_neighbors[:austin].should==[:san_antonio,:houston]
  end

  it "should find a path when there's only one" do
    (final, path)=a_star(:blacksburg, :boston, &@map_neighbors)
    final.should==:boston
    path.should==[:blacksburg, :sioux_falls, :boston]
  end

  it "should return nil when there's no path" do
    a_star(:austin,:sioux_falls, &@map_neighbors).should==nil
  end

  it "should find the shortest, when there's two" do
    (final, path)=a_star(:blacksburg, :austin, &@map_neighbors)
    path.should==[:blacksburg, :houston, :austin]
    final.should==:austin
  end
end
