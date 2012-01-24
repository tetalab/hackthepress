# encoding: utf-8

class Grapher

  # Compute a gexf containing a hierarchy with:
  #   - parlementary group 1
  #     - deputy 1
  #     - deputy 2
  #   - parlementary group 2
  #     - deputy 1
  #     - deputy 3
  # Edges will represent
  #   - between groups: the number of commun deputy in each group
  #   - between deputies: ???
  def deputy_group_hierarchy
    social_graph = {:nodes => [], :edges => []}

    index = {:node => 0, :edge => 0}

    # Include all group nodes
    Group.all.each do |group|
      social_graph[:nodes] << {:id => "group_#{group.id}", :label => group.label}
    end

    # Include all deputy nodes
    Deputy.all.each do |deputy|
      deputy_node = {:id => "deputy_#{deputy.id}", :label => deputy.slug}
      if groups = deputy.groups
        deputy_node[:parents] = []
        groups.each do |group|
          deputy_node[:parents] << "group_#{group.id}"
        end
      end
      social_graph[:nodes] << deputy_node
    end

    return generate_gexf(social_graph)
  end

  # Compute a graph with edge between each deputy
  # Edge wight will depend on the number of time 2 deputies are in the same parlementary group
  def deputy_weight_by_group_gexf
    social_graph = {:nodes => [], :edges => []}

    index = {:node => 0, :edge => 0}

    Deputy.all.each do |deputy|
      puts "analysing #{deputy.id} #{deputy.slug} with #{deputy.groups.size} groups"
      social_graph[:nodes] << {:id => deputy.id.to_f, :label => deputy.slug}
      deputy.groups.each do |group|
        puts "max edges #{group.deputies.size}"
        group.deputies.reject{|other_deputy| deputy == other_deputy}.each do |other_deputy|
          existing_edges = social_graph[:edges].select{|edge| edge[:source] == deputy.id && edge[:target] == other_deputy.id}
          unless existing_edges.empty?
            existing_edges.each{|edge| edge[:weight] += 1.0}
          else
            social_graph[:edges] << {:id => index[:edge], :source => deputy.id.to_f, :target => other_deputy.id.to_f, :weight => 1.0}
            index[:edge] += 1
          end
        end
      end
    end

    return generate_gexf(social_graph)
  end

  def generate_gexf(received_data)
    xml = Builder::XmlMarkup.new(:ident => 1)

    xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
    xml.gexf(:xmlns => "http://www.gexf.net/1.2draft", :version => "1.2") do
      xml.meta(:lastmodifieddate => Time.now.strftime("%Y-%m-%d")) do
        xml.creator "Tetalab"
        xml.description "hackthepress"
      end
      xml.graph(:mode => "static", :defaultedgetype => "directed") do
        xml.nodes{:count => received_data[:nodes].size} do
          received_data[:nodes].each do |node|
            xml.node :id => node[:id], :label => node[:label]
            if node[:parents]
              xml.parents do
                node[:parents].each do |parent|
                  xml.parent :for => parent
                end
              end
            end
          end
        end
        xml.edges{:count => received_data[:edges].size} do
          received_data[:edges].each do |edge|
            xml.edge :id => edge[:id], :source => edge[:source], :target => edge[:target], :weight => edge[:weight]
          end
        end
      end
    end
    return xml.target!
  end

  def generate_cumul_graph(opts = {})
    title = opts[:title]
    filename = opts[:filename]
    attribute = opts[:attribute]
    cumuls = opts[:cumuls]
    legend = opts[:legend]
    Gchart.bar(:title => "Semaines de présence",
               :format => 'file', :filename => filename,
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

  def show_cumul

    deputies = Deputy.all

    cumuls = [
      deputies.all(:nb_cumul => 0),
      deputies.all(:nb_cumul => 1),
      deputies.all(:nb_cumul => 2),
      deputies.all(:nb_cumul => 3),
      deputies.all(:nb_cumul => 4)
    ]

    generate_cumul_graph :title => "Semaines de présence",
                         :filename => "img/cumul_weeks.png",
                         :attribute => :activity_weeks,
                         :cumuls => cumuls,
                         :legend => "semaines"

    generate_cumul_graph :title => "Présences en commission",
                         :filename => "img/cumul_commission_presence.png",
                         :attribute => :commission_presence,
                         :cumuls => cumuls,
                         :legend => "présences"

    generate_cumul_graph :title => "Interventions en commission",
                         :filename => "img/cumul_commission_intervention.png",
                         :attribute => :commission_intervention,
                         :cumuls => cumuls,
                         :legend => "interventions"

    generate_cumul_graph :title => "Intervention en hémicycle",
                         :filename => "img/cumul_hemicycle_intervention.png",
                         :attribute => :hemicycle_intervention,
                         :cumuls => cumuls,
                         :legend => "interventions"

    generate_cumul_graph :title => "Amendements signés",
                         :filename => "img/cumul_amendements.png",
                         :attribute => :signed_amendment,
                         :cumuls => cumuls,
                         :legend => "semaines"

    generate_cumul_graph :title => "Rapports écrits",
                         :filename => "img/cumul_rapports.png",
                         :attribute => :written_report,
                         :cumuls => cumuls,
                         :legend => "rapports"

    generate_cumul_graph :title => "Propositions de loi écrites",
                         :filename => "img/cumul_propsition_loi_ecrite.png",
                         :attribute => :written_law_proposal,
                         :cumuls => cumuls,
                         :legend => "propositions"

    generate_cumul_graph :title => "Propositions de loi signées",
                         :filename => "img/cumul_proposition_loi_signe.png",
                         :attribute => :signed_law_proposal,
                         :cumuls => cumuls,
                         :legend => "propositions"

    generate_cumul_graph :title => "Questions écrites",
                         :filename => "img/cumul_question_ecrite.png",
                         :attribute => :written_question,
                         :cumuls => cumuls,
                         :legend => "questions"

    generate_cumul_graph :title => "Questions orales",
                         :filename => "img/cumul_question_orale.png",
                         :attribute => :oral_question,
                         :cumuls => cumuls,
                         :legend => "questions"
  end
end
