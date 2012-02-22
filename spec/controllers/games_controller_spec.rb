require 'spec_helper'

describe GamesController do
  render_views
  login_user
  
  before(:each) do 
    @attr = { :id => 1, :user_id => 1, :server_game_id => 1000, :status => "in_progress", :player_hits => 1, :server_hits => 1 }
  end
  
  describe "GET 'index'" do
    
    context 'Given a Player wants to view all games' do
  
      it "Then should be successful" do 
        get :index
        response.should be_success 
      end
      it "And then should have the right title" do 
        get :index
        response.should have_selector("title", :content => "Battleships") 
      end
    
    end
    
  end  
  
  describe "GET 'new'" do
    
    before(:each) do 
      @game = Game.create!(@attr)
      @response = { :game => { :id => 1000}}
      CreateGameContext.stub!(:call).and_return(@response)
    end
    
    context 'Given a Player wants to create a new game' do
  
      it "Then should be successful" do 
        get :new
        response.should be_success 
      end
    
    end
    
  end 
  
  describe "POST 'show'" do
    
    before(:each) do 
      @response = { :game => { :id => 1000}}
      @game = Game.create!(@attr)
      CreateGameContext.stub!(:call).and_return(@response)
    end
    
    context 'Given a Player wants see a game' do
  
      it "Then should be successful" do
        get :show, :id => @game.id
        response.should be_success
      end
    
    end
    
  end 
  
  describe "GET 'won'" do
    
    before(:each) do 
      @game = Game.create!(@attr)
      CreateGameContext.stub!(:call).and_return(@game)
    end
    
    context 'Given a Player has won a game' do
  
      it "Then should be successful" do
        get :won, :id => @game.id
        response.should be_success
      end
      
      it "And then there should be a titel" do
        get :won, :id => @game.id
        response.should have_selector("h1", :content => "You sank my battle ships")
      end
      
      it "And then there should be a link to create a new game" do
        get :won, :id => @game.id
        response.should have_selector("a", :content => "Yes")
      end
    
    end
    
  end
  
  describe "GET 'lost'" do
    
    before(:each) do 
      @game = Game.create!(@attr)
      CreateGameContext.stub!(:call).and_return(@game)
    end
    
    context 'Given a Player has lost a game' do
  
      it "Then should be successful" do
        get :lost, :id => @game.id
        response.should be_success
      end
      
      it "And then there should be a title" do
        get :lost, :id => @game.id
        response.should have_selector("h1", :content => "Arrr walk the plan..")
      end
      
      it "And then there should be a link to create a new game" do
        get :won, :id => @game.id
        response.should have_selector("a", :content => "Yes")
      end
    
    end
    
  end
  
end
