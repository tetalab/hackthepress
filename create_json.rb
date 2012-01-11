require 'rubygems'
require 'net/http'
require 'json'

def api_json(json_url)
  url = URI.parse(json_url)
  req = Net::HTTP::Get.new(url.path)
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  return JSON.parse(res.body)
end

groups = {}
# group: {:name => "name", :members => ["name1", "name2"]}
organismes = []
fonctions = []

fonction_weight = {
"membre" => "0.15",
"membre suppléant" => "0.20",
"membre titulaire" => "0.25",
"membre suppléante" => "0.30",
"membre du bureau" => "0.35",
"juge suppléant" => "0.40",
"juge titulaire" => "0.45",
"représentante suppléante" => "0.50",
"représentant suppléant" => "0.55",
"représentant titulaire" => "0.60",
"secrétaire général-adjoint" => "0.65",
"secrétaire" => "0.70",
"première vice-présidente" => "0.75",
"vice-présidente" => "0.80",
"vice-président" => "0.80",
"présidente déléguée" => "0.85",
"président de droit" => "0.90",
"président exécutif" => "0.95",
"président" => "1.0"
}

groupes_parlementaires = {}
# groupes_parlementaires = {"nom" => ["membre 1", "membre 2", ...],  "nom2"}


  #resp = depute_api["responsabilites_extra_parlementaires"]
  #unless resp.kind_of? String
  #  resp.each do |res|
  #    fonction = res["responsabilite"]["fonction"]
  #    organisme = res["responsabilite"]["organisme"]
  #    fonctions << fonction unless fonctions.include? fonction
  #    organismes << organisme unless organismes.include? organisme
  #    if groups.has_key? organisme
  #      groups[organisme]["members"] << depute_api["nom"]
  #    else
  #      groups[organisme] = {"members" => [depute_api["nom"]]}
  #    end
  #  end
  #end


depute_list = api_json("http://www.nosdeputes.fr/deputes/json")
depute_list["deputes"].each do |depute_json|

  depute = depute_json["depute"]
  depute_api = api_json(depute["api_url"])["depute"]

  groupes = depute_api["groupes_parlementaires"]
  unless groupes.kind_of? String
    groupes.each do |groupe|
      orga = groupe["responsabilite"]["organisme"]
      fonc = groupe["responsabilite"]["fonction"]
      if groupes_parlementaires.has_key? orga
        groupes_parlementaires[orga] << depute_api["slug"]
      else
        groupes_parlementaires[orga] = [depute_api["slug"]]
      end
    end
  end
end

p fonctions.inspect
p organismes.inspect

File.open("fonctions.txt", "w") do |file|
  fonctions.each do |fun|
    file.write fun + "\n"
  end
end

File.open("organismes.txt", "w") do |file|
  organismes.each do |fun|
    file.write fun + "\n"
  end
end

File.open("group.json", "w") do |file|
  groups.each do |fun|
    orga = fun[0]
    fun[1]["members"].each do |member|
      file.write "#{orga} -> #{member}\n"
    end
  end
end

File.open("group.dot", "w") do |file|
  file.write "digraph graphname {\n"
  groups.each do |fun|
    orga = fun[0]
    fun[1]["members"].each do |member|
      file.write "\"#{orga}\" -> \"#{member}\" [weight = #{fonction_weight}];"
    end
  end
  file.write "}"
end

amigos = groupes_parlementaires.select{|group, members| group =~/^Groupe d'amitié/}
studies = groupes_parlementaires.select{|group, members| group =~/^Groupe d'études france-/}
File.open("amigos.txt", "w") do |file|
  file.write "id,members,category,amigos\n"
  index = 0
  amigos.each_pair do |key, value|
    file.write "#{index}, #{key.gsub("Groupe d'amitié france-", "")}, #{value.size}, 1\n"
    index += 1
  end
  studies.each_pair do |key, value|
    file.write "#{index}, #{key.gsub("Groupe d'études france-", "")}, #{value.size}, 0\n"
    index += 1
  end
end

etudes = groupes_parlementaires.select{|group, members| group =~/^Groupe d'études/}
File.open("etudes.txt", "w") do |file|
  index = 0
  file.write "id,members,category\n"
  etudes.each_pair do |key, value|
    file.write "#{index}, #{value.size}, \"#{key.gsub("Groupe d'études ", "")}\"\n"
    index += 1
  end
end

