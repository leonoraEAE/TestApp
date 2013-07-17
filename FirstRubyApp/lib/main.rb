# myapp.rb


=begin

require 'sinatra'
require 'json'
require 'haml'
set :haml, { :format => :html5 }
use Rack::Logger

set :root, File.expand_path(File.dirname(__FILE__) + '/../../')

helpers do
  def logger
    request.logger
  end
end

before '/myApp' do
  request_ip = request.ip
  request_path = request.path
  puts "#{request_ip} to #{request_path}"
end

get '/myApp' do
  logger.info "matched /myApp/*"
  @owner = "Leonora" 
  # Render our Index template
  #erb :new_view
  haml :my_index
end

get '/example.json' do
  content_type :json
  [{ :id => 1, :name => 'Foo' }].to_json
end

error do
  'ERROR - ' + env['sinatra.error'].name
end

=end


require 'json'
require 'haml'
require "rubygems"
require 'sinatra/base'
require 'couchrest'
require 'couchrest_model'
require 'rest_client'

#Couch = CouchRest.new("http://admin:admin@localhost:5984")
Couch = CouchRest.new("http://mudynamics:0xVGHvbhwfMTsQhvbSWZJ@ec2-177-71-145-216.sa-east-1.compute.amazonaws.com")
DB = Couch.database('test')


class User < CouchRest::Model::Base
  use_database DB
  
  property :name
  property :phone
  property :email
  
  view_by :name, :email
  
end


class MyApp < Sinatra::Base
  set :root, File.expand_path(File.dirname(__FILE__) + '/../')

  
  #before filter
  before '/myApp' do
    request_ip = request.ip
    request_path = request.path
    puts "#{request_ip} to #{request_path}"
  end
  
  
  get '/myApp/users/all' do
    content_type :json
    #get all users
      
    #  Using the model
    #User.all.to_json
      
    #  Using the view
    records = DB.view('users/all', {:descending => true, :include_docs => true })
    rows = records['rows']
    
    rows.to_json
  end  
  
  
  get '/myApp/users/delete/:id/:rev' do 
    content_type :json
    id = params[:id]
    "delete: #{id}"
     doc = { "_id" => params[:id], 
             "_rev" => params[:rev]}
    DB.delete_doc(doc)
    redirect '/myApp'
  end
  
  delete '/myApp/users/delete' do 
    content_type :json
    id = params[:id]
    "delete: #{id}"
     doc = { "_id" => params[:id], 
             "_rev" => params[:rev]}
    DB.delete_doc(doc)
    "ok".to_json
    #redirect '/myApp'
  end
  
  post '/myApp/user/create' do
    content_type :json
    puts "#{params[:name]} - #{params[:email]} - #{params[:phone]}"
    attributes = { "name" => params[:name], 
                   "email" => params[:email], 
                   "phone" => params[:phone]}
    #create user
    User.create(attributes)
    redirect '/myApp'
  end
    

 put '/myApp/users/update' do 
    content_type :json
    puts "#{params[:name]} - #{params[:email]} - #{params[:phone]}"
    attributes = { "name" => params[:name], 
                   "email" => params[:email], 
                   "phone" => params[:phone]}
    
    payload = JSON.parse(request.body.read) rescue nil
    
    "not_found" unless payload
    
    name = payload['name'] 
    email = payload['email'] 
    
    result = DB.update_doc payload['id'] do |_doc|
      _doc['name'] = name
      _doc['email'] = email
      _doc
    end
    
    "ok".to_json
  end
  
  delete '/myApp/users/:id/:rev' do 
    content_type :json
    id = params[:id]
    "delete: #{id}"
     doc = { "_id" => params[:id], 
             "_rev" => params[:rev]}
    DB.delete_doc(doc)
    #redirect '/myApp'
  end
  
  
  
  get '/myApp' do
    # Render our Index template
    haml :my_index, :locals => {:ip => request.ip}
  end

  
  error do
    'ERROR - ' + env['sinatra.error'].name
  end
  
  
  # start the server if ruby file executed directly
  # run! if app_file == $0
end
