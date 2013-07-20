Dir["#{File.dirname(__FILE__)}/../app/**/*.rb"].each { |file| require file }
require 'factory_girl'
FactoryGirl.find_definitions
