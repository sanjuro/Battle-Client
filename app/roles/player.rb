require 'net/http'

module Player
  def create_game(game)   
    # Create game on battle service
      
    uri = URI.parse('http://127.0.0.1:9000/games?name=' + self.name + '&email=' + self.email)
    
    request = Net::HTTP::Post.new uri.request_uri
    
    response = Net::HTTP.start(uri.host, uri.port) { |http|
        http.request(request)
      }
         
    # Simulated Response from Battle Service
#    response = { :game => {:id => 1000, :status => 'in_progress'}, 
#                 :player_ships => { 
#                              :a => {:ship_id => 1, :y => 0, :x => 1}, 
#                              :b => {:ship_id => 1, :y => 0, :x => 2}, 
#                              :c => {:ship_id => 1, :y => 0, :x => 3}, 
#                              :d => {:ship_id => 1, :y => 0, :x => 4},
#                              :p => {:ship_id => 1, :y => 0, :x => 5},
#                              :e => {:ship_id => 2, :y => 8, :x => 0},
#                              :f => {:ship_id => 2, :y => 8, :x => 1},
#                              :g => {:ship_id => 2, :y => 8, :x => 2},
#                              :f => {:ship_id => 2, :y => 8, :x => 3},
#                              :g => {:ship_id => 3, :y => 1, :x => 8},
#                              :h => {:ship_id => 3, :y => 2, :x => 8}, 
#                              :i => {:ship_id => 3, :y => 3, :x => 8}, 
#                              :j => {:ship_id => 4, :y => 8, :x => 7}, 
#                              :k => {:ship_id => 4, :y => 9, :x => 7},
#                              :l => {:ship_id => 5, :y => 5, :x => 9},
#                              :m => {:ship_id => 5, :y => 6, :x => 9},
#                              :n => {:ship_id => 6, :y => 0, :x => 0},
#                              :o => {:ship_id => 7, :y => 9, :x => 9}
#                            }
#               }
    
    response =  ActiveSupport::JSON.decode(response.body)      

    # Set user and server game of new game
    game.update_attributes(:server_game_id => response["game"]["id"])

    # Allocate ships as dictated by the web service
    response["blocks"].each do |game_block|
  
      block = Block.by_game_id(game.id).where(:y => game_block["block"]["y"]).where(:x => game_block["block"]["x"]).first
      block.update_attributes(:status => game_block["block"]["status"], 
                              :game_ship_id => game_block["block"]["game_ship_id"]
                             )
    end

    return game
  end
  
  def show_game(game)   
    # Show game on battle service
          
    uri = URI.parse('http://127.0.0.1:9000/game?id=' + game.server_game_id)
    
    request = Net::HTTP::Get.new uri.request_uri
    
    response = Net::HTTP.start(uri.host, uri.port) { |http|
        http.request(request)
      }

    # Simulated Response from Battle Service
#    response = { :game => {:id => 1000, :status => 'in_progress'}, 
#                 :blocks => { 
#                              :a => {:y => 0, :x => 0, :status => 'hit', :is_server_block => false}, 
#                              :b => {:y => 0, :x => 1, :status => 'hit', :is_server_block => false}, 
#                              :c => {:y => 0, :x => 0, :status => 'hit', :is_server_block => true}, 
#                              :d => {:y => 0, :x => 1, :status => 'hit', :is_server_block => true},
#                              :e => {:y => 5, :x => 5, :status => 'hit', :is_server_block => false},
#                              :f => {:y => 5, :x => 5, :status => 'hit', :is_server_block => true}
#                            }
#               }
      
    response = ActiveSupport::JSON.decode(response.body) 
               
    # Update Status of game
    game.update_attributes(:status => response["game"]["status"])
           
    # Update all blocks to keep client in sync  
    response[:blocks].each do |block,data|
      block = Block.by_game_id(game.id).where(:x => data[:x], :y => data[:y], :is_server_block => data[:is_server_block]).first
      block.update_attributes(:status => data[:status])
    end
              
    # p response
    return game
  end
  
  def make_move(game, x_value, y_value)         
    # Create move on battle service      
    
    uri = URI.parse('http://127.0.0.1:9000/nukes')

    response = Net::HTTP.post_form(uri, 
                                   {
                                     'game_id' => game.server_game_id.to_s(),
                                     'x_value' => x_value.to_s(),
                                     'y_value' => y_value.to_s()
                                   })
   
    # Simulated Response from Battle Service
    # response = { :id => game.server_game_id, :player_status => 'hit', :y => 5, :x => 5, :server_status => 'miss', :game_status => 'in_progress'}
    response = ActiveSupport::JSON.decode(response.body) 

    # Update Game Status
    game.update_attributes(:status => response["game_status"])
    
    if response["prize"].nil?
      # Update player's blocks
      player_block = Block.by_game_id(game.id).for_player.where(:y => response["y"]).where(:x => response["x"]).first
      player_block.update_attributes(:status => response["server_status"])
        
      # Update player's blocks
      server_block = Block.by_game_id(game.id).for_server.where(:y => x_value).where(:x => y_value).first
      server_block.update_attributes(:status => response["player_status"])
    end

    return response

  end
end