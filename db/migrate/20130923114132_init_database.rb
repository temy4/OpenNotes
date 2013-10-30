class InitDatabase < ActiveRecord::Migration
	def up
		create_table :notepads, :force => true do |t|
			t.string :name
			t.integer :typeofnp
			t.integer :parent_id, :default => 0
			t.integer :order, :default => 100
		    t.datetime "created_at",  :null => false
		    t.datetime "updated_at",  :null => false
		end
		create_table :notes, :force => true do |t|
			t.string :title
			t.text :note_text
			t.text :tags
			t.integer :notepad_id
			t.integer :category_id
			t.boolean :deleted
		    t.datetime "created_at",  :null => false
		    t.datetime "updated_at",  :null => false
		end
		create_table :categories, :force => true do |t|
			t.string :name
			t.string :rgb_color
			t.string :html_class
		    t.datetime "created_at",  :null => false
		    t.datetime "updated_at",  :null => false
		end
		create_table :shortcuts, :force => true do |t|
			t.integer :note_id
		    t.datetime "created_at",  :null => false
		    t.datetime "updated_at",  :null => false
		end
	end

	def down
		drop_table :notepads
		drop_table :notes
		drop_table :categories
		drop_table :shortcuts
	end
end