require 'rubygems'
require 'sinatra'
require 'haml'

require 'whois'
require 'json'

# mongo
require 'mongo'



class App < Sinatra::Application
   get '/' do
      haml :index
   end

  post '/ajax.json' do 
    domain = params[:domain]

    begin
      info = Whois.query(domain)
    rescue Whois::ServerNotFound
    end
    content_type :json
    
    { :domain => domain, :info => {:available => info.available?, :registered => info.registered?, :expires => info.expires_on} }.to_json unless info.nil?
  end

  get '/mongo' do
  @mongo = Mongo::Connection.from_uri('mongodb://vredniy-_sinat14:sinatra@mongodb0.locum.ru/vredniy-_sinat14')
  "mongo #{@mongo.active?}"
  end

  get '/sequel' do
    require 'sequel'

    DB = Sequel.sqlite('data/production.db')
  end
end
