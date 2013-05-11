class Press
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Search

  field :topic,             type: String
  field :content,           type: String

  attr_accessible :topic, :content
  
end
