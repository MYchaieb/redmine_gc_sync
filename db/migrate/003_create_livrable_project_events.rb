class CreateLivrableProjectEvents < ActiveRecord::Migration
  def self.up
    create_table :livrable_project_events do |t|
    	t.column :project_id, :integer
    	t.column :event_id, :string
    	t.column :delivery_date, :datetime
    	t.column :heure, :time
    	t.column :logs, :text
    	t.column :title, :text
    	t.column :description, :text
    	t.column :created_at, :datetime
    	t.column :updated_at, :datetime
    end
  end

  def self.down
  	drop_table :livrable_project_events
  end
end
