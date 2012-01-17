# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Grapher" do

  after(:each) do
    Dir.glob("img/*.png").each{|f| File.unlink(f)}
  end

  it "generates cumul graph" do
    grapher = Grapher.new
    deputies = Deputy.all

    filename = "img/cumul_test.png"

    cumuls = [
      deputies.all(:nb_cumul => 0),
      deputies.all(:nb_cumul => 1),
      deputies.all(:nb_cumul => 2),
      deputies.all(:nb_cumul => 3),
      deputies.all(:nb_cumul => 4)
    ]

    grapher.generate_cumul_graph :title => "Semaines de présence",
                                 :filename => filename,
                                 :attribute => :activity_weeks,
                                 :cumuls => cumuls,
                                 :legend => "semaines"

    fail "cumul graph not generated" unless File.exists? filename
  end

  it "generate 10 graphs for cumul data" do
    grapher = Grapher.new
    grapher.show_cumul
    fail "not all graphs generated" unless Dir.glob("img/*.png").size == 10
  end
end
