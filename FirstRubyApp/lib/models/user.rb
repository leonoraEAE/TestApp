require 'couchrest'

module Models
  class User < CouchRest::Model::Base
    include ::App  
    use_database DB
    
    property :name
    property :phone
    property :email
    
    view_by :name, :email
    
  end
end
