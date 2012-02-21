require 'spec_helper' 

describe MakeMoveContext do  
  let(:user) { Factory(:user) }
  let(:game) { Factory(:game) }
    
  context "Given a Player wants to view a game" do
    it 'should call show_game on an Player' do
      context = MakeMoveContext.new(user.id, game.id, 0, 0)
      context.user.should_receive(:make_move).with(context.game, 0, 0)
      context.call
    end
  end
end