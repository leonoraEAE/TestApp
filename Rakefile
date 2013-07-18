# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

require 'rake'
require 'rspec/core/rake_task'


namespace :db do
    desc "Synchronize the views with CouchDB"
    task :sync_views do
        require 'couch_setup/sync'
        CouchSetup::Sync.views 
    end
end