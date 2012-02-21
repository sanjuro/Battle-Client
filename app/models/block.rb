class Block < ActiveRecord::Base

  STATUS_SHIP = 'has_ship'
  STATUS_HIT = 'hit'
  STATUS_MISS = 'miss'
  
  validates :game_id, :presence => true
  
  belongs_to :game

  scope :by_game_id, lambda {|game_id| where("blocks.game_id =?", game_id)}
  scope :for_player, where("blocks.is_server_block = ?", false)
  scope :for_server, where("blocks.is_server_block = ?", true)
    
end