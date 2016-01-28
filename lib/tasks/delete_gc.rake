namespace :delete_gc do
	desc "put all tasks on redmine on the specific calendar wich is configured from the plugin configuration"
	task :exec => :environment do 
		require 'colorize'
		puts "syncronizing with google calendar processing ...".yellow

		evo = IssueEvent.new 
		if evo.calendar_ready 

			evos = IssueEvent.all 
			evos.each do | e|
				e.destroy
				puts "suppression of event ##{e.issue_id}"
			end


		else
			puts "configuration is not set, please view the plugin configuration for task calendar".red
		end
	end
end