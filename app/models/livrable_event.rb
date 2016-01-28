class LivrableEvent < ActiveRecord::Base
  unloadable

  before_save :send_to_google_calendar

  before_destroy :delete_from_google_calendar




  def send_to_google_calendar

    if calendar_ready 
      begin 

        issue = Issue.find(self.issue_id)
        project = Project.find_by_id(issue.project_id)
        begin_title = TitleOfEvent.find_by(:project_id => issue.project_id)

        parent_name = project.name

        p = project
        while p.parent != nil do 
          parent_name = p.parent.name 
          p = p.parent
        end


        cal = get_acces_to_google_calendar

        event = nil

        extra = 0 

        if issue.heure_delivery != nil
          extra_time = Time.parse(issue.heure_delivery.to_s)
          extra = extra_time.hour * 3600 + extra_time.min * 60
        end

        title = ''
        if begin_title != nil 
          if begin_title.title_event != nil && begin_title.title_event != ''
            title += begin_title.title_event
          end
        end

        
        title += '[ '+ parent_name+' ] '
        title += issue.subject + '  #' +  self.issue_id.to_s

        if self.event_id == nil
          event = cal.create_event do |e|
            e.title = title 
            e.start_time = Time.parse(issue.delivery_date.to_s) + extra
            e.end_time = Time.parse(issue.delivery_date.to_s) + (60*60) + extra
            e.description = self.issue_path
            e.visibility = 'private'
          end
        else
          event = cal.find_or_create_event_by_id(self.event_id) do |e|
            e.title = title 
            e.start_time = Time.parse(issue.delivery_date.to_s) + extra
            e.end_time = Time.parse(issue.delivery_date.to_s) + (60*60) + extra
            e.description = self.issue_path 
            e.visibility = 'private'

          end
        end

        self.event_id = event.id
        Rails.logger.info "Event Created"
      rescue

        Rails.logger.error "Error while creating event on google calendar"
      end


    end
  end

  def delete_from_google_calendar
    if calendar_ready

      begin 
        cal = get_acces_to_google_calendar
        event_to_delete = cal.find_event_by_id(self.event_id)
        cal.delete_event(event_to_delete[0])
      rescue
      end

    end
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
    calendar_id = Setting.plugin_redmine_gc_sync['calendar_task_id']
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
	                :calendar => Setting.plugin_redmine_gc_sync['calendar_task_id'].to_s, 
	                :redirect_url => "urn:ietf:wg:oauth:2.0:oob",  # this is what Google uses for 'applications'
                   :refresh_token => Setting.plugin_redmine_gc_sync['refresh_token'].to_s
                   )

  	return cal
  end

end
