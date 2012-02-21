class NukesController < ApplicationController
  def new
    @nuke = Nuke.new
   
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nuke }
      format.json  { render :json => @nuke }
    end
  end
  
  def create
    game_id = params[:game_id]
    x_value = params[:x_value]
    y_value = params[:y_value]

    result = MakeMoveContext.call(current_user.id,game_id,x_value,y_value) 
  
    @game = Game.find_by_id!(game_id)
    
    @player_blocks = @game.get_player_blocks
    @server_blocks = @game.get_server_blocks
    
    respond_to do |format|
      if @game.save
        
        flash[:notice] = I18n.t('game_sent_nuke')
          
        if result["player_status"] == 'hit'
          flash[:notice] = 'You hit something.'
        end 
          
        if !result["sunk"].nil?
          flash[:notice] = 'You sunk my ' + result["sunk"]
        end 
        
        if !result["error"].nil?
          flash[:notice] = result["error"]
        end   
        
        if !result["prize"].nil?
          flash[:prize] = result["prize"]
        end 
           
        format.html  { redirect_to(game_path(@game)) }
        format.json  { render :json => @game,
                        :status => :created, :location => @game }
      else
        format.html  { render :action => "new" }
        format.json  { render :json => @game.errors,
                      :status => :unprocessable_entity }
      end
    end
  end
end