# config.ru (run with rackup)
require './lib/main.rb'


map "/" do
    run App::MyApp
end
