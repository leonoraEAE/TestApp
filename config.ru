$: << File.expand_path(File.dirname(__FILE__) + "/lib")

# config.ru (run with rackup)
require 'main'


map "/" do
    run App::MyApp
end
