require 'spec_helper' 

describe CreateGameContext do  
  let(:user) { Factory(:user) }
  let(:game) { Factory(:game) }
    
  context "Given a Player creates a new game" do
    it 'should call create_a_game on an Player' do
      context = CreateGameContext.new(user.id, game.id)
      context.user.should_receive(:create_game).with(context.game)
      context.call
    end
  end
end