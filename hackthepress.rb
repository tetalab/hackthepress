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

#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://localhost/hackthepress')
DataMapper.finalize

require 'lib/deputy'
require 'lib/parser'
require 'lib/grapher'

if ARGV[0] == "--parse"
  DataMapper.auto_migrate!
  parser = RcParser.new
  parser.parse_all
end


grapher = Grapher.new
grapher.show_cumul(Deputy.all)
