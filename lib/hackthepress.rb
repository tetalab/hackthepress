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
require 'builder'

require 'hackthepress/deputy'
require 'hackthepress/parser'
require 'hackthepress/grapher'

class HackThePress

  def initialize(opts = {})
    #DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup(:default, 'mysql://localhost/hackthepress')
    DataMapper.finalize
    if opts[:generate]
      DataMapper.auto_migrate!
      parser = RcParser.new
      parser.parse_all
    end
  end

  def graph(type)
    grapher = Grapher.new
    case type
    when "cumul"
      grapher.show_cumul
    end
  end

end
