# encoding: utf-8

class Grapher

  def generate_cumul_graph(opts = {})
    title = opts[:title]
    filename = opts[:filename]
    attribute = opts[:attribute]
    cumuls = opts[:cumuls]
    legend = opts[:legend]
    Gchart.bar(:title => "Semaines de présence",
               :format => 'file', :filename => "img/#{filename}",
               :data => [
                 [cumuls[0].sum(attribute) / cumuls[0].count],
                 [cumuls[1].sum(attribute) / cumuls[1].count],
                 [cumuls[2].sum(attribute) / cumuls[2].count],
                 [cumuls[3].sum(attribute) / cumuls[3].count],
                 [cumuls[4].sum(attribute) / cumuls[4].count],
               ],
               :stacked => false,
               :bar_colors => ['CFF09E','A8DBA8','79BD9A','3B8686','0B486B'],
               :size => "500x200",
               :legend => [
                 "#{cumuls[0].count} députés - moyenne: #{cumuls[0].sum(attribute) / cumuls[0].count} #{legend}",
                 "#{cumuls[1].count} députés - moyenne: #{cumuls[1].sum(attribute) / cumuls[1].count} #{legend}",
                 "#{cumuls[2].count} députés - moyenne: #{cumuls[2].sum(attribute) / cumuls[2].count} #{legend}",
                 "#{cumuls[3].count} députés - moyenne: #{cumuls[3].sum(attribute) / cumuls[3].count} #{legend}",
                 "#{cumuls[4].count} député  - moyenne: #{cumuls[4].sum(attribute) / cumuls[4].count} #{legend}"
               ])
  end

  def show_cumul(deputies)
    cumuls = [
      deputies.all(:nb_cumul => 0),
      deputies.all(:nb_cumul => 1),
      deputies.all(:nb_cumul => 2),
      deputies.all(:nb_cumul => 3),
      deputies.all(:nb_cumul => 4)
    ]

    generate_cumul_graph :title => "Semaines de présence",
                         :filename => "cumul_weeks.png",
                         :attribute => :activity_weeks,
                         :cumuls => cumuls,
                         :legend => "semaines"

    generate_cumul_graph :title => "Présences en commission",
                         :filename => "cumul_commission_presence.png",
                         :attribute => :commisssion_presence,
                         :cumuls => cumuls,
                         :legend => "présences"

    generate_cumul_graph :title => "Interventions en commission",
                         :filename => "cumul_commission_intervention.png",
                         :attribute => :commission_intervention,
                         :cumuls => cumuls,
                         :legend => "interventions"

    generate_cumul_graph :title => "Intervention en hémicycle",
                         :filename => "cumul_hemicycle_intervention.png",
                         :attribute => :hemicycle_intervention,
                         :cumuls => cumuls,
                         :legend => "interventions"

    generate_cumul_graph :title => "Amendements signés",
                         :filename => "cumul_amendements.png",
                         :attribute => :signed_amendment,
                         :cumuls => cumuls,
                         :legend => "semaines"

    generate_cumul_graph :title => "Rapports écrits",
                         :filename => "cumul_rapports.png",
                         :attribute => :written_report,
                         :cumuls => cumuls,
                         :legend => "rapports"

    generate_cumul_graph :title => "Propositions de loi écrites",
                         :filename => "cumul_propsition_loi_ecrite.png",
                         :attribute => :written_law_proposal,
                         :cumuls => cumuls,
                         :legend => "propositions"

    generate_cumul_graph :title => "Propositions de loi signées",
                         :filename => "cumul_proposition_loi_signe.png",
                         :attribute => :signed_law_proposal,
                         :cumuls => cumuls,
                         :legend => "propositions"

    generate_cumul_graph :title => "Questions écrites",
                         :filename => "cumul_question_ecrite.png",
                         :attribute => :written_question,
                         :cumuls => cumuls,
                         :legend => "questions"

    generate_cumul_graph :title => "Questions orales",
                         :filename => "cumul_question_orale.png",
                         :attribute => :oral_question,
                         :cumuls => cumuls,
                         :legend => "questions"
  end

  def median(x)
    sorted = x.sort
    mid = x.size/2
    sorted[mid]
  end
end
