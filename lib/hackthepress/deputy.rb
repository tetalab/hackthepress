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
