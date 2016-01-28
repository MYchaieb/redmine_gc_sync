class IssueEvent < ActiveRecord::Base
  unloadable

  before_save :send_to_google_calendar
  before_destroy :delete_from_calendar



  def delete_from_calendar

  	if calendar_ready 
  		if self.event_id != nil
  			begin
	  			cal = get_acces_to_google_calendar
	  			event_to_delete = cal.find_event_by_id(self.event_id)
	        	cal.delete_event(event_to_delete[0])
	        rescue
	        end

  		end
  	end

  end



  def send_to_google_calendar 

  	if calendar_ready 


	  	issue = Issue.find(self.issue_id)
	    project = Project.find_by_id(issue.project_id)

	    parent_name = " [" + project.name + " ]"

	    p = project
	    while p.parent != nil do 
	      parent_name += " [" + p.parent.name  + " ]"
	      p = p.parent
	    end

	    if issue.due_date == nil || issue.start_date == nil 
	    	raise "nothing to do here"
	    end

	    title = ''


	    issue_path = Setting.host_name + "/issues/" + self.issue_id.to_s

	    
	    title += parent_name.to_s + " " + issue.subject + '  #' +  self.issue_id.to_s

	    cal = get_acces_to_google_calendar

	    event = nil

	    attendee = get_attendee(issue)

	    if self.event_id == nil
	      event = cal.create_event do |e|
	        e.title = title 
	        e.start_time = Time.parse(issue.start_date.to_s) 
	        e.end_time = Time.parse(issue.due_date.to_s) 
	        e.description = issue_path
	        e.attendees = attendee
	        e.visibility = 'private'
	      end
	    else
	      event = cal.find_or_create_event_by_id(self.event_id) do |e|
	        e.title = title 
	        e.start_time = Time.parse(issue.start_date.to_s) 
	        e.end_time = Time.parse(issue.start_date.to_s) 
	        e.description = issue_path 
	        e.attendees = attendee
	        e.visibility = 'private'

	      end
	    end

	    self.event_id = event.id

  	end

  end

  def get_attendee(issue)
  	attendee = []
    is_group = false
    users = nil
    gg = nil
    if issue.assigned_to_id != nil
      
      
      begin
        users = User.find(issue.assigned_to_id)
      rescue
        gg = Group.find(issue.assigned_to_id)
        is_group = true
      end
    

    	if is_group
    		gg.users.each do |u|
    			if u.google_cal_mail != nil          
            hash = {'email' => u.google_cal_mail, 'displayName' => u.firstname , 'responseStatus' => 'tentative'}
    				attendee.push(hash)
    			end

    		end
    	else
    		if users.google_cal_mail != nil
    			attendee = [{ 'email' => users.google_cal_mail, 'displayName' => users.firstname, 'responseStatus' => 'tentative'} ]
    		end
    		
    	end

    end

  	return attendee



  end



  def calendar_ready 
  	if canledar_settings_ready == true && calendar_refres_token_ready == true
  		return true
  	else
  		return false
  	end
  	
  end

  def canledar_settings_ready
  	client_id =  Setting.plugin_redmine_gc_sync['client_id']
    client_secret = Setting.plugin_redmine_gc_sync['client_secret']
    calendar_id = Setting.plugin_redmine_gc_sync['calendar_tasks_id']
    refresh_token = Setting.plugin_redmine_gc_sync['refresh_token']

    if client_id == '' || client_secret == '' || calendar_id == '' ||  client_id == nil || client_secret == nil || calendar_id == nil 
    	return false
    else
    	return true
    end
  end

  def calendar_refres_token_ready 
  	refresh_token = Setting.plugin_redmine_gc_sync['refresh_token']
    if refresh_token == '' || refresh_token == nil
    	return false
    else
    	return true
    end
  end

  def get_acces_to_google_calendar
  	cal = Google::Calendar.new(:client_id => Setting.plugin_redmine_gc_sync['client_id'].to_s, 
	                :client_secret => Setting.plugin_redmine_gc_sync['client_secret'].to_s, 
	                :calendar => Setting.plugin_redmine_gc_sync['calendar_tasks_id'].to_s, 
	                :redirect_url => "urn:ietf:wg:oauth:2.0:oob",  # this is what Google uses for 'applications'
                   :refresh_token => Setting.plugin_redmine_gc_sync['refresh_token'].to_s
                   )

  	return cal
  end
end
