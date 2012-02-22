require 'spec_helper' 

describe Block do
  
  before(:each) do 
    @attr = { :id => 1, :game_id => 1, :x => 1, :y => 1, :is_server_block => false }
  end
  
  context 'Given a new block is created' do
    it "should create a new instance given valid attributes" do 
      Block.create!(@attr)
    end
    
    it "should require a game id" do
     no_game_block = Block.new(@attr.merge(:game_id => ""))
      no_game_block.should_not be_valid
    end

  end
  
end