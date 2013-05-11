class Position
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Search

    has_one :university, class_name: "Group"
    has_one :institute, class_name: "Group"
    belongs_to :user

    field :title,         type: String
    field :dateStart,     type: Date
    field :dateEnd,       type: Date
    field :university_token,   type: String
    field :institute_token,   type: String

    attr_accessible :title, :dateEnd, :dateStart, :university_token, :institute_token
    # attr_reader :group_token
    search_in  :title, :university => :name, :institute => :name

    before_save :assign_university, :assign_institute

    def assign_university
        unless self.university_token == nil
            self.university = Group.find(self.university_token)
        end
    end
    def assign_institute
        unless self.institute_token == nil
            self.institute = Group.find(self.institute_token)
        end
    end
end

