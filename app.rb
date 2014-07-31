require 'sinatra/base'
require 'sinatra/activerecord'
require 'rack-flash'
require 'sinatra/reloader'
require 'sinatra/partial'
require 'gschool_database_connection'

# include all .rb files in models directory
Dir['./lib/*.rb'].each { |file| require file }

class App < Sinatra::Application

  #initial application settings
  set :root, File.dirname(__FILE__)
  enable :sessions
  use Rack::Flash
  register Sinatra::ActiveRecordExtension

  #using sinatra-partials gem with settings
  register Sinatra::Partial
  set :partial_template_engine, :erb
  enable :partial_underscores

  #use reloader in development
  configure :development do
    register Sinatra::Reloader
  end

  def initialize
    super
    GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    if session[:id]
      erb :logged_in
    else
      erb :index
    end

  end

  get "/register" do
    erb :register
  end

  post "/register/new" do
      user = User.create(
        :username => params[:username],
        :password => params[:password],
        :repeat_password => params[:repeat_password] #transient value
      )
    if user.valid?
      session[:id] = user.id
      flash[:notice]="Welcome, #{params[:username]}"
      redirect "/"
    else
      error_messages = user.errors.full_messages.join("<br> ")
      flash[:notice] = error_messages
      erb :register
    end
  end

  post "/logout" do
    session.clear
    flash[:notice] = "Thank you for visiting"
    redirect "/"
  end

  post "/login" do
    if username == nil
      flash[:notice] = "Username doesn't exist"
      redirect '/'
    elsif
    password == nil
      flash[:notice] = "Password is incorrect"
      redirect '/'
    else
      session[:id] = password.id
      welcome_user
      redirect "/"
    end
  end

  private


  def username
    User.where(
    :username=>"#{params[:username]}"
    ).first
  end

  def password
    User.where(
      :username=>"#{params[:username]}",
      :password=>"#{params[:password]}"
    ).first
  end

  def welcome_user
    flash[:notice] = "Welcome, #{password.username}"
  end

end
