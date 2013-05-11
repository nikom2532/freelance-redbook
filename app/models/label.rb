class Label
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name,			:type => String

	attr_accessible :name

	def self.get_label_list
		Label.order_by("name ASC").map do |label|
			label.name
		end
	end

	

end
