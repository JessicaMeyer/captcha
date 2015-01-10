require "sinatra"
require "sinatra/reloader"
require "pg"
require 'rest_client'
require "json"
require "pry-byebug"
# require "rack-flash3" # commented out for now 
#require "rest-client"
#require "bcrypt"


# Point to Storymash 'Engine' (not needed since we are using Active Record)
# require_relative "lib/storymash.rb"

# Active Record 
require_relative 'config/environments.rb'

# Enable sessions and set up bind (for Vagrant)
configure do
  enable :sessions
  set :bind, "0.0.0.0"
end

# Set up help to connect to database. Not needed with Active Record
# helpers do
#   def db
#     db = Storymash.create_db_connection('storymash')
#   end
# end

# May be needed at a later date
# before do
#   if session[:user_id]
#     @current_user = Storymash::UsersRepo.find(db, session[:user_id])
#   end
# end

# Homepage
get "/" do
  erb :index
end

get "/signin" do
  erb :signin
end

get "/signup" do
  erb :signup
end


#Signup with username / password params.
post "/signup" do
  #user_data = {:username => params[:username], :password => params[:password]}
  #@user_save = Storymash::UsersRepo.save(db, params)
  #session["user_id:"] = @user_save["id"] 
  
  username = params[:username]
  password = params[:password]

  User.create(username: username, password: password)
  

  redirect to "/welcome"
end


# Sigin with username / password params. Create sessions
post "/signin" do
  user_data = {:username => params[:username], :password => params[:password]}
  @user_login = Storymash::UsersRepo.user_login(db, user_data)

  if @user_login["id"]
    session["user_id"] = @user_login["id"]
    redirect to "/welcome"
  else
    "login error"
    end
end


get "/welcome" do
  erb :"welcome"
end 

post "/welcome" do
  redirect to "/story/" + params['hashtag']
end

get "/story/:hashtag" do
  @data = JSON.parse RestClient.get 'https://api.instagram.com/v1/tags/'+ params['hashtag']+ '/media/recent?access_token=1523996703.abaee01.f6662a65a5304db49d14d1091b0fb65d'
  erb :"story"
end




# Sign out user - if user id exists, then remove id from session
post "/signout" do
  unless params[:id].nil?
    session.delete[params:id]
  end
  redirect to "/"
end


