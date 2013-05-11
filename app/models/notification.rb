class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :users
  has_many :groups

  field :content,			:type => String, :default => ""

end
