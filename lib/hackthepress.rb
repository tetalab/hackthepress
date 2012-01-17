$:.unshift File.dirname(__FILE__)
require 'rubygems'
require 'net/http'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'gchart'
require 'data_mapper'
require 'dm-migrations'
require 'dm-aggregates'

require 'hackthepress/deputy'
require 'hackthepress/parser'
require 'hackthepress/grapher'

class HackThePress

  def initialize(generate = false)
    #DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup(:default, 'mysql://localhost/hackthepress')
    DataMapper.finalize
    if generate
      DataMapper.auto_migrate!
      parser = RcParser.new
      parser.parse_all
    end
  end

  def graph(type)
    grapher = Grapher.new
    case type
    when "cumul"
      deputies = Deputy.all
      grapher.show_cumul(deputies)
    end
  end

end
