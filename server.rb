require "sinatra"
require "sinatra/reloader"
require "pg"
require 'rest_client'
require "json"
require "pry-byebug"
require "date"
#require "rack-flash3" # commented out for now
#require "bcrypt"


# Active Record
require_relative "config/environments.rb"


# Enable sessions and set up bind (for Vagrant)
configure do
  enable :sessions
  set :bind, "0.0.0.0"
end


# May be needed at a later date
before do
  if session["user_id"]
      @user_id = session["user_id"]
      @current_user = User.find(@user_id)
  end
end

# Homepage
get "/" do
  erb :index
end


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

  user = User.create(username: username, password: password)

  session["user_id"] = user["id"]

  redirect to "/welcome"
end

get "/signin" do
  erb :signin
end

# Sigin with username / password params. Create sessions
post "/signin" do
  #user_data = {:username => params[:username], :password => params[:password]}
  #puts params

  username = params[:username]
  password = params[:password]

  user = User.where(username: username, password: password)

  #puts user
  #puts user[0]["id"]

  redirect to "/welcome"
  # if user[0]["id"]
  #   session["user_id"] = user[0]["id"]
  #   redirect to "/welcome"
  # else
  #   "login error"
  # end


end

####################
# END OPTION: SPLIT SIGNUP/IN
####################

get "/welcome" do
  erb :welcome
end

# get "/welcome/:username" do
#   erb :"welcome"
# end

post "/welcome" do
  redirect to "/story/" + params['hashtag']
end

# post "/welcome" do
#   # redirect to "/story/" + params['hashtag'] + "?title=" + params['title'].downcase.gsub(' ', '-')
#   redirect to "/story/" + params['hashtag'] +"?start-date="+ params["date-of-start"] + "&end-date="+ params["date-of-end"]
# end

get "/story/:x" do
  puts params
  @data = JSON.parse RestClient.get 'https://api.instagram.com/v1/tags/'+ params['x']+ '/media/recent?access_token=1523996703.e61ce71.055273204cd2431c843615792dc40304'
  erb :story
end

# get "/story/:x" do
#   starttime = params["start-date"].split("-")
#   y = starttime[0].to_i
#   m = starttime[1].to_i
#   d = starttime[2].to_i
#   @startdate = Date.new(y,m,d).to_time.to_i
#   endtime = params["end-date"].split("-")
#   ey = endtime[0].to_i
#   em = endtime[1].to_i
#   ed = endtime[2].to_i
#   @enddate = Date.new(ey,em,ed).to_time.to_i
#   puts params
#   @title = params['title']

#   @data = JSON.parse RestClient.get 'https://api.instagram.com/v1/tags/'+ params['x']+ '/media/recent?access_token=1523996703.e61ce71.055273204cd2431c843615792dc40304&max_tag_id=@enddate&min_tag_id=@startdate&count=6'
#   # @data = JSON.parse RestClient.get 'https://api.instagram.com/v1/tags/'+ params['x']+ '/media/recent?access_token=1523996703.e61ce71.055273204cd2431c843615792dc40304'

#   erb :"story"
# end



# # Sign out user - if user id exists, then remove id from session
# post "/signout" do
#   unless params[:id].nil?
#     session.delete[params:id]
#   end
#   redirect to "/"
# end


