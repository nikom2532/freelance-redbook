class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Paperclip

  scope :universities, where(kind: "University")
  scope :institutes, where(kind: "Instutute")
  scope :businesses, where(kind: "Business")
  
  resourcify
  field :kind, type: String
  field :name, type: String
  field :description, type: String, :default => ""
  field :rdomain_list, :type => String 
  field :english_name,   type: String
  field :acronym,        type: String

  # Address
  field :address,        type: String
  field :city,           type: String
  field :state,          type: String
  field :country,        type: String
  field :continent,      type: String
  field :postal_code,    type: String

  # Contact info
  field :phone_country,  type: Integer
  field :phone,          type: Integer
  field :phone_extension,type: Integer
  field :email,          type: String

  # Social
  field :website,        type: String
  field :facebook,       type: String
  field :twitter,        type: String

  # verification
  field :verify_host,    type: String

  # Add Moderator
  field :group_moderator,type: String



  has_mongoid_attached_file :logo,
    :default        => 'http://placehold.it/100x100&text=logo',
    :path           => ':attachment/:id/:style.:extension',
    :storage        => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
    :styles => {
      :small   => ['48x48!!',    :jpg],
    },
    :convert_options => { :all => '-background white -flatten +matte' }

  has_mongoid_attached_file :cover,
    :default        => 'http://placehold.it/350x150&text=cover',
    :path           => ':attachment/:id/:style.:extension',
    :storage        => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
    :styles => {
      :normal   => ['350x',    :jpg],
    },
    :convert_options => { :all => '-background white -flatten +matte' }
  
  has_many :staffs, :dependent => :destroy
  has_and_belongs_to_many :users
  has_and_belongs_to_many :rdomains
  belongs_to :position, inverse_of: "university"
  belongs_to :position, inverse_of: "institute"

  

  attr_writer :rdomain_list

  def rdomain_list
    @rdomain_list || rdomains.map(&:name).join(", ")
  end

  def assign_rdomains
    if @rdomain_list
      self.rdomains = @rdomain_list.split(/,/).uniq.map do |name|
        Rdomain.where(:name => name).first || Rdomain.create(:name => name.strip)
      end
    end
  end

  before_save :assign_rdomains, :assign_mod
  
  has_many :subgroups   , :inverse_of => :parentgroups, :class_name => 'Group', :autosave => true
  belongs_to :parentgroups, :inverse_of => :subgroups, :class_name => 'Group', :autosave => true
  
  accepts_nested_attributes_for :subgroups, :parentgroups



  attr_accessible :name, :kind, :research_domain, :logo, :cover, :description, :rdomain_list, :address, :city, :state, :country, :postal_code, :phone, :phone_country, :phone_extension, :email, :website, :facebook, :twitter, :verify_host, :group_moderator, :english_name, :acronym
  validates_presence_of :name, :kind

  def assign_mod
    # assign mod before save
    if self.group_moderator != nil or self.group_moderator != ""
      self.group_moderator.gsub(/\s+/, "").split(/,/).uniq do |mod|
        user = User.find_by({username: mod});
        user.add_role :moderator, self
        user.save
      end
    end
  end

  def full_address
    city = ""
    state = ""
    country = ""
    postal_code = ""

    city = (", " + self.city) if self.city?
    state = (", " + self.state) if self.state?
    country = (", " + self.country) if self.country?
    postal_code = (", " + self.postal_code) if self.postal_code?

    return "%s %s %s %s %s" % [self.address, city, state, country, postal_code ]
  end

  def moderator 
  	temp = self.roles.where(:name => "moderator").first
  	if(temp!=nil)
  		return temp.users
  	else
  		return []
  	end
  end
  
  def is_child(temp)
  	if self.parentgroups == temp
  		return true
  	elsif self.parentgroups == nil
  		return false
  	else
  		return self.parentgroups.is_child(temp)
  	end
  end
  
  after_save :update_tags

    private
      def update_tags
        self.subgroups.each do |sub|
          sub.save
        end
      end
  
  search_in :name, :parentgroups => :_keywords 
  
end
