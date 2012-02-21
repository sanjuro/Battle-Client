class GamesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @games = Game.by_user_id(current_user.id).order('created_at DESC')
    
    @games_won_count = Game.by_user_id(current_user.id).won.count
    @games_lost_count = Game.by_user_id(current_user.id).lost.count
    
    respond_to do |format|
      format.html { render :layout => true } # new.html.erb
      format.xml  { render :xml => @games_in_progress }
      format.json  { render :json => @games_in_progress }
    end
  end
  
  def new
    @game = Game.create(:user_id => current_user.id)

    CreateGameContext.call(current_user.id, @game.id)
    
    @player_blocks = @game.get_player_blocks
    @server_blocks = @game.get_server_blocks
    
    # should redirect to show page
    respond_to do |format|
      if @game.save
        format.html  { redirect_to( game_path(@game),
                      :success => 'Game was successfully created.') }
        format.json  { render :json => @game,
                      :status => :created, :location => @game }
      else
        format.html  { render :action => "new" }
        format.json  { render :json => @game.errors,
                      :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @game = Game.find_by_id!(params[:id])
    # response = ShowGameContext.call(current_user.id, @game)
    
    @player_blocks = @game.get_player_blocks
    @server_blocks = @game.get_server_blocks
  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
      format.json  { render :json => @game }
    end
  end
  
  def won
    @game = Game.find_by_id!(params[:id])
      
    respond_to do |format|
      format.html # won.html.erb
      format.xml  { render :xml => @game }
      format.json  { render :json => @game }
    end
  end
  
  def lost
    @game = Game.find_by_id!(params[:id])
      
    respond_to do |format|
      format.html # lost.html.erb
      format.xml  { render :xml => @game }
      format.json  { render :json => @game }
    end
  end
end
