class CreateBattleships < ActiveRecord::Migration
  def self.up   
    create_table :blocks do |t|
      t.integer :game_id
      t.integer :game_ship_id
      t.integer :x
      t.integer :y
      t.string :status, :default => "in_play"
      t.boolean :is_server_block, :default => false

      t.timestamps
    end
    
    create_table :games do |t|
      t.references "user"
      t.integer :server_game_id 
      t.string :status, :default => "in_progress"
      t.integer :server_hits, :default => 0
      t.integer :player_hits, :default => 0

      t.timestamps
    end
  end
  
  def self.down
  
  end
end