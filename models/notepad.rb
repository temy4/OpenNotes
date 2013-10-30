class Notepad < ActiveRecord::Base
	has_many :notes
	has_many :sections, :class_name => 'Notepad', foreign_key: "parent"
	belongs_to :parents, :class_name => 'Notepad'
end