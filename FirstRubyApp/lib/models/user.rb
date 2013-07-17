require 'models/base'

module Models
  
  class User < CouchRest::Model::Base
    use_database DB
    
    property :name
    property :phone
    property :email
    
    view_by :name
    
  end
  
end



