class Rdomain
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,	:type => String

  attr_accessible :name
  
  def self.get_rdomain_list
    Rdomain.order_by("name ASC").map do |tag|
      rdomain.name
    end
  end
end
