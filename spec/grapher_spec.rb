# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Grapher" do
  it "generates cumul graph" do
    grapher = Grapher.new
    deputies = Deputy.all

    cumuls = [
      deputies.all(:nb_cumul => 0),
      deputies.all(:nb_cumul => 1),
      deputies.all(:nb_cumul => 2),
      deputies.all(:nb_cumul => 3),
      deputies.all(:nb_cumul => 4)
    ]

    grapher.generate_cumul_graph :title => "Semaines de présence",
                                 :filename => "cumul_weeks.png",
                                 :attribute => :activity_weeks,
                                 :cumuls => cumuls,
                                 :legend => "semaines"

    fail "cumul graph not generated" unless File.exists? "img/cumul_weeks.png"
  end

  it "generates filename graph" do
    grapher = Grapher.new
    deputies = Deputy.all

    cumuls = [
      deputies.all(:nb_cumul => 0),
      deputies.all(:nb_cumul => 1),
      deputies.all(:nb_cumul => 2),
      deputies.all(:nb_cumul => 3),
      deputies.all(:nb_cumul => 4)
    ]

    grapher.generate_cumul_graph :title => "Semaines de présence",
                                 :filename => "cumul.png",
                                 :attribute => :activity_weeks,
                                 :cumuls => cumuls,
                                 :legend => "semaines"

    fail "filename not generated" unless File.exists? "img/cumul.png"
  end

  it "generate 10 graphs for cumul data" do
    grapher = Grapher.new
    grapher.show_cumul
    fail "not all graphs generated" unless Dir.glob("img/*.png").size == 10
  end
end
