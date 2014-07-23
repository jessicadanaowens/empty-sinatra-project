require 'sinatra/base'
require 'sinatra/activerecord'
require 'rack-flash'
require 'sinatra/reloader'

# include all .rb files in models directory
Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |file| require file }

class App < Sinatra::Application

  #initial application settings
  set :root, File.dirname(__FILE__)
  enable :sessions
  use Rack::Flash
  register Sinatra::ActiveRecordExtension

  #use reloader in development
  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    erb :index
  end

end