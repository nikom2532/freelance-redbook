class Staff
  include Mongoid::Document
  field :role, type: String
  
  belongs_to :group
  has_and_belongs_to_many :users
  
  validates_presence_of :role, :group
end
