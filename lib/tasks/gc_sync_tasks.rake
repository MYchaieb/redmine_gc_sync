namespace :gc_sync_tasks do
	desc "put all tasks on redmine on the specific calendar wich is configured from the plugin configuration"
	task :exec => :environment do 
		require 'colorize'
		puts "syncronizing with google calendar processing ...".yellow

		evo = IssueEvent.new 
		if evo.calendar_ready 

			issues = Issue.all
			yes = 0
			no = 0
			issues.each do |issue|
			
				if !issue.respect_filters 
					next
				end

				if issue.due_date == nil  || issue.due_date == ''
					next
				end
				

				event = IssueEvent.find_by(:issue_id => issue.id)
				if event == nil 
					event = IssueEvent.new
				end
				event.issue_id = issue.id
				event.project_id = issue.project_id
				begin

					event.save
					puts " EVENT CREATED FOR ISSUE ##{issue.id} "
				rescue
					puts "event not created for ISSUE ##{issue.id} ".red
					puts  "#{issue.subject}".red
					puts  "due date : #{issue.due_date.to_s}".red
					puts  "start date : #{issue.start_date}".red
				end
				
				

			end

		else
			puts "configuration is not set, please view the plugin configuration for task calendar".red
		end
	end
end