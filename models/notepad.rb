class Notepad < ActiveRecord::Base
	has_many :notes
	has_many :sections, :class_name => 'Notepad', foreign_key: "parent"
	belongs_to :parents, :class_name => 'Notepad'
	attr_accessor :notes_count
	def attributes
	  super.merge({'notes_count' => 0})
	end
end