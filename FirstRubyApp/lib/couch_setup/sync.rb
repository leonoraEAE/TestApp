require 'couch_setup/views'
require 'couchrest'
require 'json'
require 'pp'

#Synchronizing views
module CouchSetup
  #Couch = CouchRest.new("http://admin:admin@localhost:5984")
  Couch = CouchRest.new("http://mudynamics:0xVGHvbhwfMTsQhvbSWZJ@ec2-177-71-145-216.sa-east-1.compute.amazonaws.com")
  DB = Couch.database('test');

    class Sync
        def self.update_design_doc design, debug=false
            design_id = design['_id']
            begin
                doc = DB.get design_id
            rescue RestClient::ResourceNotFound
                doc = nil
            end
            if doc
                #only update a design document if a view or filter changed
                if doc['views'] != design['views'] or 
                        doc['filters'] != design['filters']
                    
                  puts "couch: updating #{design_id}" if debug 
                  doc = DB.update_doc design_id do |_doc|
                      _doc['views'] = design['views']
                      _doc['filters'] = design['filters']
                      _doc
                  end
                end
            else
                #create a new design document
                puts "couch: creating #{design_id}" if debug
                doc = DB.save_doc design
            end
        end

        def self.views debug=false
            CouchSetup::VIEWS.each do |design|
                Sync.update_design_doc design.dup, debug
            end
        end
    end
end
