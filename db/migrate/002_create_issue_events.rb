class CreateIssueEvents < ActiveRecord::Migration[5.0]
  def self.up
    create_table :issue_events do |t|
    	t.column :project_id, :integer
    	t.column :issue_id , :integer
    	t.column :event_id, :string
    end
  end

  def self.down
  	drop_table :issue_events
  end
end
