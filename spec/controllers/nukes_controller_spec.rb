require 'spec_helper'

describe NukesController do
  render_views
  login_user
  
  before(:each) do 
    @attr_game = { :id => 1, :user_id => 1, :server_game_id => 1000, :status => "in_progress", :player_hits => 1, :server_hits => 1 }
    @attr_nuke = { :id => 1, :game_id => 1, :x => 1, :y => 1, :status => "in_play", :is_server_block => false }
  end
  
  describe "POST 'create'" do
    
    context 'Given a Player send a new nuke' do
      before(:each) do 
        @game = Game.create!(@attr_game)
        MakeMoveContext.stub!(:call).and_return(@game)
        @nuke = { :user_id => 1, :game_id => 1, :x => 1, :y => 1 }
      end
      
      describe "success" do
        it "Then should create a new nuke" do
          lambda do
            MakeMoveContext.should_receive(:new)
            post :create, :nuke => @nuke
          end
          response.should be_success
        end
        
        it 'And then update the player and server board' do
          
        end
      end
  end
    
  end
  
end