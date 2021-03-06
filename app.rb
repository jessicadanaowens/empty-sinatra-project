require 'sinatra/base'
require 'sinatra/activerecord'
require 'rack-flash'
require 'sinatra/reloader'
require 'sinatra/partial'
require 'gschool_database_connection'
require 'aws-sdk'

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

      @photos = Photo.where(
        :user_id => session[:id]
      )

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
    if User.find_by_username(params[:username]) == nil
      flash[:notice] = "Username doesn't exist"
      redirect '/'
    elsif
    User.find_by_password(params[:username], params[:password]) == nil
      flash[:notice] = "Password is incorrect"
      redirect '/'
    else
      session[:id] = User.find_by_password(params[:username], params[:password]).id
      welcome_user
      redirect "/"
    end
  end

  post "/photos" do

    image = params[:Image]
    filename = image[:filename]

    s3_url = S3_file.new(image).path.to_s

    Photo.new.upload(session[:id], filename, s3_url)

    S3_file.new(image).write
    redirect "/"
  end

  get "/photos/:id" do
    @s3_url = Photo.where(
      :id => params[:id]
    ).first.tempfile
    erb :work_table
  end

  delete "/photos/:id" do

    photo = Photo.where(
      :id => params[:id]
    ).first.filename

    S3_file_delete.new(photo).delete

    Photo.where(
    :id => params[:id]
    ).first.destroy

    redirect back

  end

  private

  def welcome_user
    name = User.find_by_password(params[:username], params[:password]).username
    if name
      flash[:notice] = "Welcome, #{name}"
    end
  end

end