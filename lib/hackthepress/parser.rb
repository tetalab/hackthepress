class Parser

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

        unless depute_api["groupes_parlementaires"].kind_of? String
          depute_api["groupes_parlementaires"].each do |group_api|
            depute.groups << Group.first_or_create(:label => group_api["responsabilite"]["organisme"])
          end
        end

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
