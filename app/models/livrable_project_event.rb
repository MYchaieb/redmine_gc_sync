class LivrableProjectEvent < ActiveRecord::Base
  unloadable
  before_save :save_to_google_calendar
  before_destroy :delete_from_google_calendar


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
    calendar_id = Setting.plugin_redmine_gc_sync['calendar_id']
    refresh_token = Setting.plugin_redmine_gc_sync['refresh_token']

    if client_id == '' || client_secret == '' || calendar_id == '' || client_id == nil || client_secret == nil || calendar_id == nil 
      return false
    else 
      return true
    end
  end


  def delete_from_google_calendar
    cal = get_acces_to_google_calendar
    event_to_delete = cal.find_event_by_id(self.event_id)
    cal.delete_event(event_to_delete[0])
  end

  def calendar_refres_token_ready
    refresh_token = Setting.plugin_redmine_gc_sync['refresh_token']
    if refresh_token == '' || refresh_token == nil
      return false
    else 
      return true
    end
  end


  def save_to_google_calendar
  	
  	cal = get_acces_to_google_calendar
  	project = Project.find_by_id(self.project_id)

  	

    extra = 0 
    if self.heure != "" && self.heure != nil
      t = Time.parse(self.heure.to_s)
      extra = (t.hour * 3600 )+ (t.min * 60)
    end
  	if self.event_id == nil
  		event = cal.create_event do |e|
  			e.title = self.title
  			e.start_time = Time.parse(self.delivery_date.to_s) + extra
  			e.description = self.description
  			e.end_time = Time.parse(self.delivery_date.to_s) + (60 * 60) + extra
  			e.visibility = 'private'
  		end
  	else
  		event = cal.find_or_create_event_by_id(self.event_id) do |e|
  			e.title = self.title
  			e.start_time = Time.parse(self.delivery_date.to_s) + extra
  			e.end_time = Time.parse(self.delivery_date.to_s) + (60 * 60) + extra
  			e.description = self.description
  			e.visibility = 'private'
  		end

  	end

  	self.event_id = event.id
  end

  def get_acces_to_google_calendar 

    cal = Google::Calendar.new(:client_id => Setting.plugin_redmine_gc_sync['client_id'].to_s, 
                  :client_secret => Setting.plugin_redmine_gc_sync['client_secret'].to_s, 
                  :calendar => Setting.plugin_redmine_gc_sync['calendar_id'].to_s, 
                  :redirect_url => "urn:ietf:wg:oauth:2.0:oob",  # this is what Google uses for 'applications'
                             :refresh_token => Setting.plugin_redmine_gc_sync['refresh_token'].to_s
                             )

    return cal
  end

end
