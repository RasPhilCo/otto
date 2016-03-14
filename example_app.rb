require 'sinatra'
require 'mongoid'
configure do
Mongoid.load!('./config/mongoid.yml', :development)
end
class Fact
include Mongoid::Document
field :description, type: String
field :type, type: String
end
get '/facts' do
content_type :json
Fact.all.to_json
end
class User
include Mongoid::Document
field :name, type: String
end
get '/hi' do
'hello'
end
