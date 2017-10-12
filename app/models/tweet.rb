class Tweet < ApplicationRecord

	before_validation :link_check

	belongs_to :user

	has_many :tweet_tags
	has_many :tags, through: :tweet_tags

	validates :message, presence: true, length:{ maximum: 140, too_long: "A tweet is only 140 max. Everbody knows that"}

	after_validation :apply_link, on: :create

	private 

	def apply_link
		array = self.message.split
		index = array.map { |x| x.include?("http://") || x.include?("https://")}.index(true)
	 	if index
			url = array[index]
			array[index] = "<a href='#{self.link}' target='_blank'>#{url}</a>"
		end 
		self.message = array.join(" ")
	end

	def link_check

		if self.message.include? "http://"
			check = true
		elsif self.message.include? "https://"
			check = true 
		else
			check = false
		end 

		if check == true 
			array = self.message.split
			index = array.map{ |x| x.include? "http"}.index(true)
			self.link = array[index]
			if array[index].length > 23
				array[index] = "#{array[index][0..20]}..."
			end 
			self.message = array.join(" ")

		end 
	end 
end
