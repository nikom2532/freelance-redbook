class Message
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Search


  # belongs_to :message_sender, :class_name => 'User', :inverse_of => :messages_sent
  # belongs_to :message_recipient, :class_name => 'User', :inverse_of => :messages_received

  # Relationships
  belongs_to :sender, :class_name => 'User', :inverse_of => :messages_sent
  belongs_to :receiver, :class_name => 'User', :inverse_of => :messages_received
  # has_many :receivers, :class_name => 'User', :foreign_key=> 'from_user_id' # Experiment
  belongs_to :thread, :class_name => 'Message'  # Reference to parent message
  has_many :replies,  :class_name => 'Message', :foreign_key => 'thread_id'
  scope :in_reply_to, lambda { |message| where({:thread => message}).asc('created_at') }


	has_and_belongs_to_many :labels
  # has_many :receiver, :class_name => "User"


	search_in  :labels => :name


	field :subject,			:type => String
	field :body,		:type => String
  field :receivers, :type => Array

	attr_accessible :subject, :body, :label_list
	
  
  field :label_list, :type => String 
  # Adds a writer for tag_list
  attr_writer :label_list


  # Assign tags before saving post
  before_save :assign_labels

  # Get a comma separated tag list
  def label_list
    @label_list || labels.map(&:name).join(", ")
  end

  # Assigns tags from a comma separated tag list
  def assign_labels
    if @label_list
      self.labels = @label_list.split(/,/).uniq.map do |name|
        Label.where(:name => name).first || Label.create(:name => name.strip)
      end
    end
  end 

  def get_label_list
    label_list = ""
    self.labels.each do |label|
      label_list += label.name + ", "
    end
    return label_list
  end


end
