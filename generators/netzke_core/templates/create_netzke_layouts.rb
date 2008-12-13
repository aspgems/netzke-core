class CreateNetzkeLayouts < ActiveRecord::Migration
  def self.up
    create_table :layouts do |t|
      t.string  :widget_name
      t.string  :items_class
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :layouts
  end
end
