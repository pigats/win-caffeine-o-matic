require 'compass'
require 'susy'
require 'sinatra'


configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views/stylesheets'
    config.images_dir = 'images'
    config.output_style = :compressed if Sinatra::Base.production?
  end
  set :sass, Compass.sass_engine_options
end

get '/stylesheets/:name' do 
  sass :"stylesheets/#{params[:name]}"
end

get '/javascripts/:name' do 
  coffee :"javascripts/#{params[:name]}"
end

get '/' do 
  haml :index
end
