require 'json'
require 'haml'
require "rubygems"
require 'sinatra/base'
require 'couchrest'
require 'couchrest_model'
require 'rest_client'

module App
Couch = CouchRest.new(ENV['COUCHDB_URL'] || "http://admin:admin@localhost:5984")
DB = Couch.database(ENV['DB_NAME'] || 'test_db')


class MyApp < Sinatra::Base
  set :root, File.expand_path(File.dirname(__FILE__) + '/../')
  
  #before filter
  before '/myApp' do
    require 'newrelic_rpm'
    request_ip = request.ip
    request_path = request.path
    puts "#{request_ip} to #{request_path}"
  end
  
  
  get '/myApp/users/all' do
    #prod = production?
    #STDOUT.puts "production? ==> #{qq}"
    STDOUT.puts "RPM detected environment: #{NewRelic::LocalEnvironment.new}"
    return
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
                   "phone" => params[:phone], 
                   "type" => "User"
                   }
    #create user
    #User.create(attributes)
    
    Models::Base::save attributes
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
    
    Models::Base::delete doc
    #redirect '/myApp'
  end
  
  
  
  get '/myApp' do
    # Render our Index template
    haml :my_index, :locals => {:ip => request.ip}
  end
  
  get '/' do
    redirect '/myApp'
  end

  
  error do
    'ERROR - ' + env['sinatra.error'].name
  end
  
  get '/mu-e36d3723-2a3b7825-454f166b-db6e0dd4' do
    '42'
  end
  
  get '/mu-db0434f2-63bb009a-cf44430d-efc6bc7d' do
    '42'
  end
  
  get '/mu-b4c7609f-83170c27-3e4fef09-22193488' do
    '42'
  end
  
  get '/mua-*' do
   '42'
  end
  
  get '/myApp/error' do
    errors = [400, 403, 401, 404, 500]
    value = Random.rand(4);
    halt errors[value], "This is an  error"
  end
  
  # start the server if ruby file executed directly
  # run! if app_file == $0
end
end

require_relative './models/base'
require_relative './models/user'