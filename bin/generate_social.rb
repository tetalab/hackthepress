$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hackthepress'

DataMapper.setup(:default, 'mysql://localhost/hackthepress')
DataMapper.finalize

grapher = Grapher.new
File.open(File.join(File.dirname(__FILE__), '..', 'data', 'deputy_group_hierarchy.gexf'), "w") do |f|
  f.write grapher.deputy_group_hierarchy
end
