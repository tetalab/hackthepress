# encoding: utf-8

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

class Deputy
  include DataMapper::Resource

  property :id, Serial
  property :slug, String
  
  property :activity_weeks,           Integer
  property :commission_presence,      Integer
  property :commission_intervention,  Integer
  property :hemicycle_intervention,   Integer
  property :signed_amendment,         Integer
  property :written_report,           Integer
  property :written_law_proposal,     Integer
  property :signed_law_proposal,      Integer
  property :written_question,         Integer
  property :oral_question,            Integer

  property :nb_cumul, Integer, :default => 0

  def is_cumul
    return @nb_cumul > 0
  end
end

DataMapper.finalize
if ARGV[0] == "--parse"
  DataMapper.auto_migrate!
end

class RcParser

  attr_reader :deputies

  def initialize
    @deputies = []
  end

  def parse_all
    depute_list = api_json("http://www.nosdeputes.fr/deputes/json")
    depute_list["deputes"].each{|json| parse_depute(json["depute"]["api_url"])}
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

  def parse_depute(url)
    depute_api = api_json(url)["depute"]

    # do not treat desactivated deputies
    if depute_api["mandat_fin"].nil?

      # verify if deputy already exists in DB
      unless depute = Deputy.first(:slug => depute_api["slug"])
        depute = Deputy.new(:slug => depute_api["slug"])
        depute.nb_cumul = depute_api["autres_mandats"].size unless depute_api["autres_mandats"].kind_of?(String)
        parse_html_info(depute)
        depute.save
      end
      @deputies << depute
    end
  end

  def parse_html_info(depute)
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
        depute.signed_amendment = num
      when 6
        depute.written_report = num
      when 7
        depute.written_law_proposal = num
      when 8
        depute.signed_law_proposal = num
      when 9
        depute.written_question = num
      when 10
        depute.oral_question = num
      end
      index += 1
    end
  end
end

class Grapher
  def show_cumul(deputies)
    puts "Cumul"
    cumul_0 = deputies.all :nb_cumul => 0
    cumul_1 = deputies.all :nb_cumul => 1
    cumul_2 = deputies.all :nb_cumul => 2
    cumul_3 = deputies.all :nb_cumul => 3
    cumul_4 = deputies.all :nb_cumul => 4
    puts Gchart.bar(:title => "Semaines de présence",
                    :data => [
                      [cumul_0.sum(:activity_weeks) / cumul_0.count],
                      [cumul_1.sum(:activity_weeks) / cumul_1.count],
                      [cumul_2.sum(:activity_weeks) / cumul_2.count],
                      [cumul_3.sum(:activity_weeks) / cumul_3.count],
                      [cumul_4.sum(:activity_weeks) / cumul_4.count],
                    ],
                    :stacked => false,
                    :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
                    :size => "500x200",
                    :legend => [
                      "Non cumul: #{cumul_0.count} députés - moyenne: #{cumul_0.sum(:activity_weeks) / cumul_0.count} semaines",
                      "Non cumul: #{cumul_1.count} députés - moyenne: #{cumul_1.sum(:activity_weeks) / cumul_1.count} semaines",
                      "Non cumul: #{cumul_2.count} députés - moyenne: #{cumul_2.sum(:activity_weeks) / cumul_2.count} semaines",
                      "Non cumul: #{cumul_3.count} députés - moyenne: #{cumul_3.sum(:activity_weeks) / cumul_3.count} semaines",
                      "Non cumul: #{cumul_4.count} député  - moyenne: #{cumul_4.sum(:activity_weeks) / cumul_4.count} semaines"
                    ])
    puts Gchart.bar(:title => "Présences en commision",
                    :data => [
                      [cumul_0.sum(:commission_presence) / cumul_0.count],
                      [cumul_1.sum(:commission_presence) / cumul_1.count],
                      [cumul_2.sum(:commission_presence) / cumul_2.count],
                      [cumul_3.sum(:commission_presence) / cumul_3.count],
                      [cumul_4.sum(:commission_presence) / cumul_4.count],
                    ],
                    :stacked => false,
                    :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
                    :size => "500x200",
                    :legend => [
                      "Non cumul: #{cumul_0.count} députés - moyenne: #{cumul_0.sum(:commission_presence) / cumul_0.count} présences",
                      "Non cumul: #{cumul_1.count} députés - moyenne: #{cumul_1.sum(:commission_presence) / cumul_1.count} présences",
                      "Non cumul: #{cumul_2.count} députés - moyenne: #{cumul_2.sum(:commission_presence) / cumul_2.count} présences",
                      "Non cumul: #{cumul_3.count} députés - moyenne: #{cumul_3.sum(:commission_presence) / cumul_3.count} présences",
                      "Non cumul: #{cumul_4.count} député  - moyenne: #{cumul_4.sum(:commission_presence) / cumul_4.count} présences"
                    ])
    puts Gchart.bar(:title => "Interventions en commission",
                    :data => [
                      [cumul_0.sum(:commission_intervention) / cumul_0.count],
                      [cumul_1.sum(:commission_intervention) / cumul_1.count],
                      [cumul_2.sum(:commission_intervention) / cumul_2.count],
                      [cumul_3.sum(:commission_intervention) / cumul_3.count],
                      [cumul_4.sum(:commission_intervention) / cumul_4.count],
                    ],
                    :stacked => false,
                    :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
                    :size => "500x200",
                    :legend => [
                      "Non cumul: #{cumul_0.count} députés - moyenne: #{cumul_0.sum(:commission_intervention) / cumul_0.count} interventions",
                      "Non cumul: #{cumul_1.count} députés - moyenne: #{cumul_1.sum(:commission_intervention) / cumul_1.count} interventions",
                      "Non cumul: #{cumul_2.count} députés - moyenne: #{cumul_2.sum(:commission_intervention) / cumul_2.count} interventions",
                      "Non cumul: #{cumul_3.count} députés - moyenne: #{cumul_3.sum(:commission_intervention) / cumul_3.count} interventions",
                      "Non cumul: #{cumul_4.count} député  - moyenne: #{cumul_4.sum(:commission_intervention) / cumul_4.count} interventions"
                    ])
    puts Gchart.bar(:title => "Intervention en hémicycle",
                    :data => [
                      [cumul_0.sum(:hemicycle_intervention) / cumul_0.count],
                      [cumul_1.sum(:hemicycle_intervention) / cumul_1.count],
                      [cumul_2.sum(:hemicycle_intervention) / cumul_2.count],
                      [cumul_3.sum(:hemicycle_intervention) / cumul_3.count],
                      [cumul_4.sum(:hemicycle_intervention) / cumul_4.count],
                    ],
                    :stacked => false,
                    :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
                    :size => "500x200",
                    :legend => [
                      "Non cumul: #{cumul_0.count} députés - moyenne: #{cumul_0.sum(:hemicycle_intervention) / cumul_0.count} interventions",
                      "Non cumul: #{cumul_1.count} députés - moyenne: #{cumul_1.sum(:hemicycle_intervention) / cumul_1.count} interventions",
                      "Non cumul: #{cumul_2.count} députés - moyenne: #{cumul_2.sum(:hemicycle_intervention) / cumul_2.count} interventions",
                      "Non cumul: #{cumul_3.count} députés - moyenne: #{cumul_3.sum(:hemicycle_intervention) / cumul_3.count} interventions",
                      "Non cumul: #{cumul_4.count} député  - moyenne: #{cumul_4.sum(:hemicycle_intervention) / cumul_4.count} interventions"
                    ])
    puts Gchart.bar(:title => "Amendements signés",
                    :data => [
                      [cumul_0.sum(:signed_amendment) / cumul_0.count],
                      [cumul_1.sum(:signed_amendment) / cumul_1.count],
                      [cumul_2.sum(:signed_amendment) / cumul_2.count],
                      [cumul_3.sum(:signed_amendment) / cumul_3.count],
                      [cumul_4.sum(:signed_amendment) / cumul_4.count],
                    ],
                    :stacked => false,
                    :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
                    :size => "500x200",
                    :legend => [
                      "Non cumul: #{cumul_0.count} députés - moyenne: #{cumul_0.sum(:signed_amendment) / cumul_0.count} amendements",
                      "Non cumul: #{cumul_1.count} députés - moyenne: #{cumul_1.sum(:signed_amendment) / cumul_1.count} amendements",
                      "Non cumul: #{cumul_2.count} députés - moyenne: #{cumul_2.sum(:signed_amendment) / cumul_2.count} amendements",
                      "Non cumul: #{cumul_3.count} députés - moyenne: #{cumul_3.sum(:signed_amendment) / cumul_3.count} amendements",
                      "Non cumul: #{cumul_4.count} député  - moyenne: #{cumul_4.sum(:signed_amendment) / cumul_4.count} amendements"
                    ])
    puts Gchart.bar(:title => "Rapports écrits",
                    :data => [
                      [cumul_0.sum(:written_report) / cumul_0.count],
                      [cumul_1.sum(:written_report) / cumul_1.count],
                      [cumul_2.sum(:written_report) / cumul_2.count],
                      [cumul_3.sum(:written_report) / cumul_3.count],
                      [cumul_4.sum(:written_report) / cumul_4.count],
                    ],
                    :stacked => false,
                    :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
                    :size => "500x200",
                    :legend => [
                      "Non cumul: #{cumul_0.count} députés - moyenne: #{cumul_0.sum(:written_report) / cumul_0.count} rapports",
                      "Non cumul: #{cumul_1.count} députés - moyenne: #{cumul_1.sum(:written_report) / cumul_1.count} rapports",
                      "Non cumul: #{cumul_2.count} députés - moyenne: #{cumul_2.sum(:written_report) / cumul_2.count} rapports",
                      "Non cumul: #{cumul_3.count} députés - moyenne: #{cumul_3.sum(:written_report) / cumul_3.count} rapports",
                      "Non cumul: #{cumul_4.count} député  - moyenne: #{cumul_4.sum(:written_report) / cumul_4.count} rapports"
                    ])
    puts Gchart.bar(:title => "Propositions de loi écrites",
                    :data => [
                      [cumul_0.sum(:written_law_proposal) / cumul_0.count],
                      [cumul_1.sum(:written_law_proposal) / cumul_1.count],
                      [cumul_2.sum(:written_law_proposal) / cumul_2.count],
                      [cumul_3.sum(:written_law_proposal) / cumul_3.count],
                      [cumul_4.sum(:written_law_proposal) / cumul_4.count],
                    ],
                    :stacked => false,
                    :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
                    :size => "500x200",
                    :legend => [
                      "Non cumul: #{cumul_0.count} députés - moyenne: #{cumul_0.sum(:written_law_proposal) / cumul_0.count} propositions",
                      "Non cumul: #{cumul_1.count} députés - moyenne: #{cumul_1.sum(:written_law_proposal) / cumul_1.count} propositions",
                      "Non cumul: #{cumul_2.count} députés - moyenne: #{cumul_2.sum(:written_law_proposal) / cumul_2.count} propositions",
                      "Non cumul: #{cumul_3.count} députés - moyenne: #{cumul_3.sum(:written_law_proposal) / cumul_3.count} propositions",
                      "Non cumul: #{cumul_4.count} député  - moyenne: #{cumul_4.sum(:written_law_proposal) / cumul_4.count} propositions"
                    ])
    puts Gchart.bar(:title => "Propositions de loi signées",
                    :data => [
                      [cumul_0.sum(:signed_law_proposal) / cumul_0.count],
                      [cumul_1.sum(:signed_law_proposal) / cumul_1.count],
                      [cumul_2.sum(:signed_law_proposal) / cumul_2.count],
                      [cumul_3.sum(:signed_law_proposal) / cumul_3.count],
                      [cumul_4.sum(:signed_law_proposal) / cumul_4.count],
                    ],
                    :stacked => false,
                    :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
                    :size => "500x200",
                    :legend => [
                      "Non cumul: #{cumul_0.count} députés - moyenne: #{cumul_0.sum(:signed_law_proposal) / cumul_0.count} propositions",
                      "Non cumul: #{cumul_1.count} députés - moyenne: #{cumul_1.sum(:signed_law_proposal) / cumul_1.count} propositions",
                      "Non cumul: #{cumul_2.count} députés - moyenne: #{cumul_2.sum(:signed_law_proposal) / cumul_2.count} propositions",
                      "Non cumul: #{cumul_3.count} députés - moyenne: #{cumul_3.sum(:signed_law_proposal) / cumul_3.count} propositions",
                      "Non cumul: #{cumul_4.count} député  - moyenne: #{cumul_4.sum(:signed_law_proposal) / cumul_4.count} propositions"
                    ])
    puts Gchart.bar(:title => "Questions écrites",
                    :data => [
                      [cumul_0.sum(:written_question) / cumul_0.count],
                      [cumul_1.sum(:written_question) / cumul_1.count],
                      [cumul_2.sum(:written_question) / cumul_2.count],
                      [cumul_3.sum(:written_question) / cumul_3.count],
                      [cumul_4.sum(:written_question) / cumul_4.count],
                    ],
                    :stacked => false,
                    :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
                    :size => "500x200",
                    :legend => [
                      "Non cumul: #{cumul_0.count} députés - moyenne: #{cumul_0.sum(:written_question) / cumul_0.count} questions",
                      "Non cumul: #{cumul_1.count} députés - moyenne: #{cumul_1.sum(:written_question) / cumul_1.count} questions",
                      "Non cumul: #{cumul_2.count} députés - moyenne: #{cumul_2.sum(:written_question) / cumul_2.count} questions",
                      "Non cumul: #{cumul_3.count} députés - moyenne: #{cumul_3.sum(:written_question) / cumul_3.count} questions",
                      "Non cumul: #{cumul_4.count} député  - moyenne: #{cumul_4.sum(:written_question) / cumul_4.count} questions"
                    ])
    puts Gchart.bar(:title => "Questions Orales",
                    :data => [
                      [cumul_0.sum(:oral_question) / cumul_0.count],
                      [cumul_1.sum(:oral_question) / cumul_1.count],
                      [cumul_2.sum(:oral_question) / cumul_2.count],
                      [cumul_3.sum(:oral_question) / cumul_3.count],
                      [cumul_4.sum(:oral_question) / cumul_4.count],
                    ],
                    :stacked => false,
                    :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
                    :size => "500x200",
                    :legend => [
                      "Non cumul: #{cumul_0.count} députés - moyenne: #{cumul_0.sum(:oral_question) / cumul_0.count} questions",
                      "Non cumul: #{cumul_1.count} députés - moyenne: #{cumul_1.sum(:oral_question) / cumul_1.count} questions",
                      "Non cumul: #{cumul_2.count} députés - moyenne: #{cumul_2.sum(:oral_question) / cumul_2.count} questions",
                      "Non cumul: #{cumul_3.count} députés - moyenne: #{cumul_3.sum(:oral_question) / cumul_3.count} questions",
                      "Non cumul: #{cumul_4.count} député  - moyenne: #{cumul_4.sum(:oral_question) / cumul_4.count} questions"
                    ])

  end
end

if ARGV[0] == "--parse"
  parser = RcParser.new
  parser.parse_all
end


grapher = Grapher.new
grapher.show_cumul(Deputy.all)
