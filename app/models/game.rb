class Game < ActiveRecord::Base
  
  STATUS_IN_PROGRESS = 'in_progress'
  STATUS_WON = 'won'
  STATUS_LOST = 'lost'
  MAX_HITS = 18
  
  validates :user_id, :presence => true

  scope :by_user_id, lambda {|user_id| where("games.user_id =?", user_id)}
  scope :by_server_game_id, lambda {|server_game_id| where("games.server_game_id =?", server_game_id)}
  scope :won, where("games.status = 'won'")
  scope :lost, where("games.status = 'lost'")
  scope :in_progress, where("games.status = 'in_progress'")
  
  has_many :blocks
  
  after_create :create_blocks_for_game
  
  def create_blocks_for_game
    # create player_board
    10.times do |x|
      10.times do |y|
        Block.create(:game_id => self.id, :x => x, :y => y, :is_server_block => false)
      end
    end

    # create server_board
    10.times do |x|
      10.times do |y|
        Block.create(:game_id => self.id, :x => x, :y => y, :is_server_block => true)
      end
    end
  end
  
  def get_player_blocks
    unordered_blocks = Block.where(:game_id => self.id, :is_server_block => false).order(:x)
    blocks = Hash.new
   
    unordered_blocks.each do |block|
      blocks[[block.y,block.x]] = block.status
    end
 
    return blocks
  end
  
  def get_server_blocks
    unordered_blocks =  Block.where(:game_id => self.id, :is_server_block => true).order(:x)
    blocks = Hash.new
   
    unordered_blocks.each do |block|
      blocks[[block.y,block.x]] = block.status
    end
 
    return blocks
  end
end