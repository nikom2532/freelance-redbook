class Project
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Slug

  has_and_belongs_to_many :rdomains
  belongs_to :user

  search_in :name, :description
  
  field :name,              type: String
  field :scope,             type: String
  field :rdomain_list,      type: String
  field :deadline,          type: Date
  field :budget,            type: Integer
  field :description,       type: String

  # Restrict participant
  field :city,              type: String
  field :country,           type: String
  field :region,            type: String
  field :continent,         type: String

  attr_accessible :rdomain_list, :name, :scope, :research_domain, :deadline, :budget, :description, :country, :region, :continent, :image, :city
  attr_writer :rdomain_list
  before_save :assign_rdomains
  validates_presence_of :name
  slug :name, :deadline

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

  has_mongoid_attached_file :image,
    :default        => 'http://placehold.it/350x150&text=image',
    :path           => ':attachment/:id/:style.:extension',
    :storage        => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
    :styles => {
      :normal   => ['350x',    :jpg],
    },
    :convert_options => { :all => '-background white -flatten +matte' }

  

end
