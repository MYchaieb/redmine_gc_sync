class CreateLivrableEvents < ActiveRecord::Migration
  def self.up
    create_table :livrable_events do |t|
    	t.column :project_id, :integer
    	t.column :issue_id , :integer
    	t.column :event_id, :string
      t.column :delivery_date, :datetime
    	t.column :created_at, :timestamp
    	t.column :updated_at, :datetime
    	t.column :logText, :text
    	t.column :issue_path, :string
    end
    add_column :users, 'google_cal_mail', :string 
    add_column :issues, 'delivery_date', :string
    add_column :issues, 'heure_delivery', :string
  end

  def self.down
  	drop_table :livrable_events
  	remove_column :users, 'google_cal_mail'
  	remove_column :issues, 'delivery_date'
    remove_column :issues, 'heure_delivery'
  end
end
