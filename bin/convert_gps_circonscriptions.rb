# encoding: utf-8
require 'csv'
origin_csv = "/Users/alx/Downloads/Regions_departements_circonscriptions_communes_gps.csv"
output_csv = "circonscription_geoloc.csv"

circonscription_rows = CSV.read(origin_csv, {:headers => false, :col_sep => ";"})

circonscriptions = {}

circonscription_rows.each do |row|
  p row
  code = row[0] + "-" + row[3] + "-" + row[6]
  lat = row[10].to_f
  lon = row[11].to_f

  if lat && lon
    if circonscriptions.has_key? code
      circonscriptions[code][:cumul_lat] += lat
      circonscriptions[code][:cumul_lon] += lon
      circonscriptions[code][:points] += 1
    else
      circonscriptions[code] = {:points => 1, :cumul_lat => lat, :cumul_lon => lon}
    end
  end
end

CSV.open(output_csv, "w") do |csv|
    csv << ["code_régions", "code_département", "code_circonscription", "latitude", "longitude"]
    circonscriptions.each do |key, value|
      region, departement, circonscription = key.split "-"
      lat = value[:cumul_lat] / value[:points]
      lon = value[:cumul_lon] / value[:points]
      csv << [region, departement, circonscription, lat, lon]
    end
end
