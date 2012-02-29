require 'net/http'

module Player
  def create_game(game)   
    # Create game on battle service
      
    uri = URI.parse('http://0.0.0.0:9000/games?name=' + self.name + '&email=' + self.email)
    
    request = Net::HTTP::Post.new uri.request_uri
    
    response = Net::HTTP.start(uri.host, uri.port) { |http|
        http.request(request)
      }
    
    response =  ActiveSupport::JSON.decode(response.body)      

    # Set user and server game of new game
    game.update_attributes(:server_game_id => response["game"]["id"])

    # Allocate ships as dictated by the web service
    response["cells"].each do |game_block|
      p game_block
      block = Block.by_game_id(game.id).where(:y => game_block["cell"]["y"]).where(:x => game_block["cell"]["x"]).first 
      block.update_attributes(
          :status => game_block["cell"]["status"], 
          :game_ship_id => game_block["cell"]["game_ship_id"]
       )
    end

    return game
  end
  
  def show_game(game)   
    # Show game on battle service
          
    uri = URI.parse('http://0.0.0.0:9000/game?id=' + game.server_game_id.to_s())
    
    request = Net::HTTP::Get.new uri.request_uri
    
    response = Net::HTTP.start(uri.host, uri.port) { |http|
        http.request(request)
      }
      
    response = ActiveSupport::JSON.decode(response.body) 

    # Update game attributes
    game.update_attributes(:status => response["game"]["game"]["status"])
    game.update_attributes(:player_hits => response["game"]["game"]["player_hits"])
    game.update_attributes(:server_hits => response["game"]["game"]["server_hits"])
    
    # Update all blocks to keep client in sync  
    response["cells"].each do |cell|
      block_for_update = Block.by_game_id(game.id).where(:x => cell["cell"]["x"], :y => cell["cell"]["y"], :is_server_block => false).first
      block_for_update.update_attributes(:status => cell["cell"]["status"])
    end
              
    # p response
    return response
  end
  
  def make_move(game, x_value, y_value)         
    # Create move on battle service      
    
    uri = URI.parse('http://0.0.0.0:9000/nukes')

    response = Net::HTTP.post_form(uri, 
                                   {
                                     'game_id' => game.server_game_id.to_s(),
                                     'x_value' => x_value.to_s(),
                                     'y_value' => y_value.to_s()
                                   })
   
    # Simulated Response from Battle Service
    # response = { :id => game.server_game_id, :player_status => 'hit', :y => 5, :x => 5, :server_status => 'miss', :game_status => 'in_progress'}
    response = ActiveSupport::JSON.decode(response.body) 

    # Update game attributes
    game.update_attributes(:status => response["game"]["game"]["status"])
    game.update_attributes(:player_hits => response["game"]["game"]["player_hits"])
    game.update_attributes(:server_hits => response["game"]["game"]["server_hits"])
      
    # Update player's blocks
    player_block = Block.by_game_id(game.id).for_player.where(:y => response["y"]).where(:x => response["x"]).first
    player_block.update_attributes(:status => response["server_status"])
      
    # Update player's blocks
    server_block = Block.by_game_id(game.id).for_server.where(:y => x_value).where(:x => y_value).first
    server_block.update_attributes(:status => response["player_status"])
    
    return response

  end
end