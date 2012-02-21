class ShowGameContext
  attr_reader :user, :game

  def self.call(user_id, game)
    ShowGameContext.new(user_id, game).call
  end

  def initialize(user_id, game)
    @game = game
    @user = User.find(user_id)
    @user.extend Player
  end

  def call
    @user.show_game(@game)
  end
end