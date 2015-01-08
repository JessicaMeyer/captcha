require "sinatra"
require "sinatra/reloader"
require "pg"
require "pry-byebug"
require "rack-flash3"
#require "rest-client"
#require "bcrypt"


# Point to Storymash 'Engine'
require_relative "lib/storymash.rb"

# Enable sessions and set up bind (for Vagrant)
configure do
  enable :sessions
  set :bind, "0.0.0.0"
end

# Set up help to connect to database
helpers do
  def db
    db = Storymash.create_db_connection('storymash')
  end
end

# May be needed at a later date
before do
  if session[:user_id]
    @current_user = Storymash::UsersRepo.find(db, session[:user_id])
  end
end

# Homepage
get "/" do
  erb :index
end

## Q - MODAL PAGE??
get "/signup" do
  erb :"index/signup"
end

# Signup with username / password params.
post "/signup" do
  user_data = {:username => params[:username], :password => params[:password]}
  @user_save = Storymash::UsersRepo.save(db, params)
  session["user_id:"] = @user_save["id"]   #user id (int)

  redirect to "/"
end

# Sigin with username / password params. Create sessions
post "/signin" do
  user_data = {:username => params[:username], :password => params[:password]}
  @user_login = Storymash::UsersRepo.user_login(db, user_data)

  if @user_login["id"]
    session["user_id"] = @user_login["id"]
    redirect to "/"
  else
    "login error"
    end
end

# Sign out user - if user id exists, then remove id from session
post "/signout" do
  unless params[:id].nil?
    session.delete[params:id]
  end
  redirect to "/"
end


