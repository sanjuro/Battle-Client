require 'spec_helper' 

describe Game do
  
  before(:each) do 
    @attr = { :id => 1, :user_id => 1, :server_game_id => 1000, :status => "in_progress", :player_hits => 1, :server_hits => 1 }
  end
  
  context 'Given a new game is created' do
    it "should create a new instance given valid attributes" do 
      Game.create!(@attr)
    end
    
    it "should require a user id" do
     no_user_game = Game.new(@attr.merge(:user_id => ""))
     no_user_game.should_not be_valid
    end
    
    it "should create 200 blocks" do
     expect { Game.create(@attr) }.to change(Block, :count).by(200)
    end
  end
  
  context 'Given a all player blocks needs to be shown' do
    it "should show 100 player blocks" do 
      game = Game.create!(@attr)
      blocks = game.get_player_blocks
      blocks.count.should == 100
    end
  end
  
  context 'Given a all server blocks needs to be shown' do
    it "should show 100 server blocks" do 
      game = Game.create!(@attr)
      blocks = game.get_server_blocks
      blocks.count.should == 100
    end
  end
end