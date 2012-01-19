$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hackthepress'

DataMapper.setup(:default, 'mysql://localhost/hackthepress')
DataMapper.finalize

grapher = Grapher.new
File.open("social.gexf", "w") do |f|
  f.write grapher.social_gexf
end
