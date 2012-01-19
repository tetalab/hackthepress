$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hackthepress'

DataMapper.setup(:default, 'mysql://localhost/hackthepress')
DataMapper.auto_migrate!
DataMapper.finalize

parser = Parser.new
parser.parse_all
