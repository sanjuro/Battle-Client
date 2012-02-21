class MakeMoveContext
  attr_reader :user, :game
  
  def self.call(user_id, game_id, x_value, y_value)
    MakeMoveContext.new(user_id, game_id, x_value, y_value).call
  end
  
  def initialize(user_id, game_id, x_value, y_value)
    @game = Game.find(game_id)
    @user = User.find(user_id)
    @user.extend Player
    @x_value = x_value
    @y_value = y_value
  end
  
  def call
    @user.make_move(@game, @x_value, @y_value)
  end
end