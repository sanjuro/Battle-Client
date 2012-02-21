require 'spec_helper' 

describe Player do
  let(:user) { mock_model User, :id => 1, :email => "test@eaxmple.com" , :name => "Test", :password => "rad6hia" }
  let(:game) { Factory(:game) }
  let(:block) { Factory(:block) }
    
  before do
    user.extend Player
  end

  context 'Given a Player creates a new game' do
    it 'Then a new game call must be sent to the Battle Service' do

    end
    
    it 'And then a new game with a new server game id should be created' do
      game_create = Game.create( :user_id => 1, :server_game_id => '' , :status => "in_progress" )
      user.create_game(game_create)
      game_create.server_game_id.should == 1000
    end
    
    it 'And then it should have 200 new blocks' do
      block_count = game.blocks.count
      block_count.should == 200
    end
  end
  
  context 'Given a Player shows a game' do
    it 'Then a show call must be sent to the Battle Service' do

    end
    
    it 'And then the status of the game needs to be updated from the Battle Service' do
      game_show = Game.create( :user_id => 1, :server_game_id => 1000 , :status => '' )
      user.show_game(game_show)
      game.status.should == 'in_progress'
    end
    
    it 'And then all blocks for the game should update' do
      game_show = Game.create( :user_id => 1, :server_game_id => 1000 , :status => '' )
      user.show_game(game_show)
      block_show = game_show.blocks.first
      block_show.status.should == 'hit'
    end
  end
  
  describe 'Given a Player creates a new nuke' do
    it 'Then a the nuke must be sent to the Battle Service' do

    end
    
    it 'And the game status must be updated' do
      game_nuke = Game.create( :user_id => 1, :server_game_id => 1000 , :status => 'won' )
      user.make_move(game_nuke, 0, 1)
      game.status.should == 'in_progress'
    end
  end
end