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
require_relative "config/environments.rb"


# Enable sessions and set up bind (for Vagrant)
configure do
  enable :sessions
  set :bind, "0.0.0.0"
end

# Set up help to connect to database. Not needed with Active Record
#helpers do
#  def db
#    db = Storymash.create_db_connection('storymash')
#  end
#end

# May be needed at a later date
before do
  if session["user_id"]
#     Update this to reflect AR usage
      @user_id = session["user_id"]
      @current_user = User.find(@user_id)
      #@current_user = User.find_by(session[:user_id])
  end
end

# Homepage
get "/" do
  erb :index
end

# Signinup page
# get "/signinup" do
#   erb :signinup
# end

# post "/signup" do

#   username = params[:username]
#   password = params[:password]

#   #@user = User.create(username: username, password: password)
#   User.create(username: username, password: password)

#   #session["user_id"] = @user[id] 

#   redirect to "/welcome"
# end


####################
# OPTION:  SPLIT SIGNUP/IN
####################

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

  @user = User.create(username: username, password: password)
  
  session["user_id"] = @user["id"] 

  redirect to "/welcome"
end


get "/signin" do
  erb :signin
end

# Sigin with username / password params. Create sessions
post "/signin" do
  #user_data = {:username => params[:username], :password => params[:password]}
  @user_login = User.find_by(@user_id)

  if @user_login["id"]
    session["user_id"] = @user_login["id"]
    redirect to "/welcome"
  else
    "login error"
  end
end

####################
# END OPTION: SPLIT SIGNUP/IN 
####################


get "/welcome" do
  erb :"welcome"
end 

post "/welcome" do
  # redirect to "/story/" + params['hashtag'] + "?title=" + params['title'].downcase.gsub(' ', '-')
  redirect to "/story/" + params['hashtag']
end

get "/story/:x" do
  puts params  
  @title = params['title']
  @data = JSON.parse RestClient.get 'https://api.instagram.com/v1/tags/'+ params['x']+ '/media/recent?access_token=1523996703.e61ce71.055273204cd2431c843615792dc40304&max_tag_id=137867725&min_tag_id=137599885'
  erb :"story"
end



# # Sign out user - if user id exists, then remove id from session
# post "/signout" do
#   unless params[:id].nil?
#     session.delete[params:id]
#   end
#   redirect to "/"
# end


