class CreateTitleOfEvents < ActiveRecord::Migration[5.0]
  def self.up
    create_table :title_of_events do |t|
    	t.column :project_id, :integer
    	t.column :title_event, :text
    end
  end

  def self.down
  	drop_table :title_of_events
  end
end
