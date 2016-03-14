require 'yaml'
require 'mongoid'
require './lib/app_factory'

config = YAML.load_file('otto.yml')
# puts config.inspect
app_factory = AppFactory.build(config)

fname = "app.rb"
app = File.open(fname, "w")
app.puts "require 'sinatra'"
app.puts app_factory
app.close

# print <<`EOC`
#   ruby app.rb
# EOC
