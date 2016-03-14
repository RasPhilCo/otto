require 'ostruct'

module AppFactory
  def self.build(config)
    s = OpenStruct.new(config)
    if s.database
      d = s.database
      database = Database.new(d).publish
    end

    if s.resources
      rs = s.resources
      resources = rs.map { |r| Model.new(r).publish }
    end

    if s.routes
      extra_routes = s.routes.map {|r| Route.new(r).publish}
    end

    return [database, resources, extra_routes] # strings to print to app.rb
  end
end

class Database
  attr_reader :require_statement, :configure_statment
  def initialize(config)
    @require_statement = "require 'mongoid'"
    @configure_statment = %W(configure\ do Mongoid.load!('#{config}',\ :development) end)
  end

  def publish
    [require_statement, configure_statment]
  end
end

# module ResourceFactory
#   def self.build(config)
#     m = Model.new(config)
#   end
# end

class Model
  attr_reader :configure_statment, :routes
  def initialize(args)
    m = OpenStruct.new(args)
    fields = m.attributes.map {|atr| make_attribute(atr)}
    @configure_statment = %W(class\ #{m.name.capitalize}  include\ Mongoid::Document)
    fields.each{|f| @configure_statment.push(f) }
    @configure_statment.push("end")
    @routes = m.routes.map{|r| Route.new(r, model: m.name.capitalize)} if m.routes
  end

  def publish
    if routes
      [configure_statment, routes.map{|r|r.publish}]
    else
      [configure_statment]
    end
  end

  private
  def make_attribute(args)
    field = args[0]
    type = args[1]
    @include_statement = "field :#{field}, type: #{type.capitalize}"
  end
end


class Route
  attr_reader :defintion
  def initialize(args, extra={})
    # {"path"=>"/all", "verb"=>"get", "response"=>{"query"=>"all", "type"=>"json"}}
    args = OpenStruct.new(args)
    verb = args.verb
    path = args.path
    query = args.response['query']

    response = args.response
    if response.class == Hash
      response_type = args.response.fetch('type', nil)
      response_type ? content_type = "content_type\ :#{response_type}" : content_type = nil
      m = extra[:model]
      action = "#{m}.#{query}"
      action = "#{action}.to_json" if response_type == 'json'
    else
      action = "'#{response}'"
    end

    @defintion = %W(#{verb}\ '#{path}'\ do)
    @defintion.push(content_type) if content_type
    @defintion.push(action)
    @defintion.push("end")
  end

  def publish
    [defintion]
  end
end


# Database
# Model
# Endpoint
# AppFactory: all
# ResourceFactory: model & endpoint(s)
