# encoding: utf-8

class Grapher

  def show_cumul(deputies)
    puts "Cumul"
    cumul_0 = deputies.all :nb_cumul => 0
    cumul_1 = deputies.all :nb_cumul => 1
    cumul_2 = deputies.all :nb_cumul => 2
    cumul_3 = deputies.all :nb_cumul => 3
    cumul_4 = deputies.all :nb_cumul => 4
    puts Gchart.bar(:title => "Semaines de présence",
                    :format => 'file', :filename => 'img/cumul_weeks.png',
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
                    :format => 'file', :filename => 'img/cumul_commission_presence.png',
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
                    :format => 'file', :filename => 'img/cumul_commission_intervention.png',
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
                    :format => 'file', :filename => 'img/cumul_hemicycle_intervention.png',
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
                    :format => 'file', :filename => 'img/cumul_amendements.png',
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
                    :format => 'file', :filename => 'img/cumul_rapports.png',
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
                    :format => 'file', :filename => 'img/cumul_propsition_loi_ecrite.png',
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
                    :format => 'file', :filename => 'img/cumul_proposition_loi_signe.png',
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
                    :format => 'file', :filename => 'img/cumul_question_ecrite.png',
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
                    :format => 'file', :filename => 'img/cumul_question_orale.png',
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

  def median(x)
    sorted = x.sort
    mid = x.size/2
    sorted[mid]
  end
end
