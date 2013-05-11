class User
  include Mongoid::Document
  rolify
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Search
  include Mongoid::Slug

  has_many :messages_received,  :class_name => 'Message', :foreign_key=> 'to_user_id', :inverse_of => :sender
  has_many :messages_sent,      :class_name => 'Message', :foreign_key=> 'from_user_id', :inverse_of => :receiver
  # belongs_to :messages_sent,    :class_name => 'Message', :inverse_of => :receiver # Experiment
  has_many :positions
  
  search_in :firstname, :lastname, :rdomains => :name 

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :authentication_keys => [:login]

  ## Database authenticatable
  field :username,           :type => String
  field :firstname,          :type => String
  field :lastname,           :type => String
  field :middlename,         :type => String
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  slug :username

  validates_uniqueness_of :email, :username
  validates_presence_of :email, :username
  validates_presence_of :encrypted_password
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time
  attr_accessor :login

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  # Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  # Zombie
  field :is_zombie,            :type => Boolean, :default => true

  # Social
  field :website,             :type => String
  field :facebook,            :type => String
  field :twitter,             :type => String
  field :linkedin,            :type => String

  # Research
  field :rdomain_list,        :type => String

  # Invitation
  field :invitation_token,    :type => String

  # before_validation :invitation_check?

  def invitation_check?
    invitation = Invitation.find_by(email:self.email)
    if self.invitation_token != invitation.invitation_token
      errors.add :invitation_token, "is not on our beta list"
    end
  end


  attr_writer :rdomain_list
  before_save :assign_rdomains

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

  def displayname
    return "%s %s" % [self.firstname, self.lastname]
  end

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })

  attr_accessible :role_ids, :as => :admin
  attr_accessible :login, :username, :firstname, :lastname, :middlename, :facebook, :twitter, :website, :linkedin, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at, :is_zombie, :avatar, :rdomain_list, :facebook, :twitter, :linkedin, :invitation_token
  has_and_belongs_to_many :rdomains
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :staffs
 
  

  
  after_create :assign_default_role

  has_mongoid_attached_file :avatar,
  :default_url       => "http://placehold.it/350x150&text=avatar",
  :path           => ':attachment/:id/:style.:extension',
  :storage        => :s3,
  :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
  :styles => {
    :small => ['32x', :png],
    :medium   => ['220x100!',    :png],
    :large  => ['600x',    :png]

  },
  :convert_options => { :all => '-background white -flatten +matte' } 

  # validates :avatar, :attachment_presence => true

  def self.get_user_list
    Label.order_by("name ASC").map do |label|
      label.name
    end
  end

  def assign_default_role
    self.add_role :user_role
  end


  
  def title
  	if self.has_role? :admin
  		return "admin"
  	elsif self.has_role? :user_role
  		if self.is_zombie == true
  			return "zombie"
  		else
  			return "approved user"
  		end
  	end
  end
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      self.any_of({ :username =>  /^#{Regexp.escape(login)}$/i }, { :email =>  /^#{Regexp.escape(login)}$/i }).first
    else
      super
    end
  end

  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   login = conditions.delete(:login)
  #   where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  # end

end
