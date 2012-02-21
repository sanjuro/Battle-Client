class ShowGameContext
  attr_reader :user, :game

  def self.call(user_id, game_id)
    ShowGameContext.new(user_id, game_id).call
  end

  def initialize(user_id, game_id)
    @game = Game.find(game_id)
    @user = User.find(user_id)
    @user.extend Player
  end

  def call
    @user.show_game(@game)
  end
end