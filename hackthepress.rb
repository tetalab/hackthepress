require 'rubygems'
require 'net/http'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'gchart'
require 'data_mapper'
require  'dm-migrations'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://localhost/hackthepress')

class Deputy
  include DataMapper::Resource

  property :id, Serial
  property :slug, String
  
  property :activity_weeks,           Integer
  property :commission_presence,      Integer
  property :commission_intervention,  Integer
  property :hemicycle_intervention,   Integer
  property :written_report,           Integer
  property :written_law_proposal,     Integer
  property :signed_law_proposal,      Integer
  property :written_question,         Integer
  property :oral_question,            Integer

  property :is_cumul, Boolean, :default => false
end

DataMapper.finalize
DataMapper.auto_migrate!

class RcParser

  attr_reader :deputies

  def initialize
    @deputies = []
  end

  def parseAll
    depute_list = api_json("http://www.nosdeputes.fr/deputes/json")
    depute_list["deputes"].each do |depute_json|
      depute_api = api_json(depute_json["depute"]["api_url"])["depute"]
      depute = Deputy.new(:slug => depute_api["slug"],
                          :is_cumul => !depute_api["autres_mandats"].kind_of?(String))
      parseHtmlInfo(depute)
      depute.save
      @deputies << depute
    end
  end

  protected

  def api_json(json_url)
    url = URI.parse(json_url)
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    return JSON.parse(res.body)
  end

  def parseHtmlInfo(depute)
    url = "http://www.nosdeputes.fr/" +  depute.slug
    doc = Nokogiri::HTML(open(url))
    index = 1
    doc.css(".barre_activite img").each do |activite|
      activite["alt"].scan(/^(\d+)/)
      num = $1.to_i
      case index
      when 1
        depute.activity_weeks = num
      when 2
        depute.commission_presence = num
      when 3
        depute.commission_intervention = num
      when 4
        depute.hemicycle_intervention = num
      when 5
        depute.written_report = num
      when 6
        depute.written_law_proposal = num
      when 7
        depute.signed_law_proposal = num
      when 8
        depute.written_question = num
      when 9
        depute.oral_question = num
      end
      index += 1
    end
  end

end

parser = RcParser.new
parser.parseAll
