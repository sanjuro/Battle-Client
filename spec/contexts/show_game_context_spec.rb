require 'spec_helper' 

describe ShowGameContext do  
  let(:user) { Factory(:user) }
  let(:game) { Factory(:game) }
    
  context "Given a Player wants to view a game" do
    it 'should call show_game on an Player' do
      context = ShowGameContext.new(user.id, game.id)
      context.user.should_receive(:show_game).with(context.game)
      context.call
    end
  end
end