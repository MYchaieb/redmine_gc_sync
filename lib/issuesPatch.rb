module IssuePatchDeliveryDate 
	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do 

			unloadable

			safe_attributes :delivery_date, :if => lambda {|issue, current_user| current_user.allowed_to?(:edit_delivery_date,issue.project)}
      safe_attributes :heure_delivery, :if => lambda {|issue, current_user| current_user.allowed_to?(:edit_delivery_date,issue.project)}
      before_save :regle_heure
			after_save :save_to_google_calendar
      # after_save :update_issue_event
		end


	end

	module InstanceMethods
    def set_delivery_date
      self.delivery_date ||= DateTime.new       
    end

    def regle_heure
      if self.heure_delivery != nil && self.heure_delivery != ""
        begin
          time = Time.parse(self.heure_delivery)
          self.heure_delivery = time.strftime "%H:%M"
        rescue
          self.heure_delivery = nil
        end
      end

      if self.heure_delivery == nil || self.heure_delivery == ""
        self.heure_delivery = nil
      end
    	# self.delivery_date = nil
    end

    def issue_url
      url_host = Setting.host_name
      return url_host +"/issues/"+self.id.to_s
    end

    def respect_filters
      trackers = Setting.plugin_redmine_gc_sync['trackers'].map{|id| id.to_i}
      status = Setting.plugin_redmine_gc_sync['status'].map{|id| id.to_i}
      inclued_tracker = trackers.include?(self.tracker_id )
      include_status = status.include? (self.status_id)
      rep = include_status && inclued_tracker
      return rep 
    end

    def update_issue_event
      

      evo = IssueEvent.new 

      if evo.calendar_ready 

        event = IssueEvent.find_by(:issue_id => self.id)
        if self.respect_filters || !self.respect_filters
          if self.due_date != nil && self.due_date != ''

            if event == nil 
              event = IssueEvent.new
            end
            event.issue_id = self.id
            event.project_id = self.project_id
            begin

              event.save
            rescue
            end
              
          end
        end

      end

    end

    def save_to_google_calendar

      livrable_event = LivrableEvent.find_by(:issue_id => self.id)
      liv = LivrableEvent.new 

      @project = Project.find(self.project_id)

      if liv.calendar_ready
        if self.delivery_date != nil && self.delivery_date != ""

          if livrable_event == nil 
            livrable_event = LivrableEvent.new
            livrable_event.created_at = DateTime.now
          end
          livrable_event.project_id = self.project_id
          livrable_event.issue_id = self.id
          livrable_event.delivery_date = DateTime.parse(self.delivery_date)
          livrable_event.updated_at = DateTime.now
          livrable_event.issue_path = issue_url

          if User.current.allowed_to?(:edit_delivery_date,project)
            livrable_event.save
          end

          
        else
          if livrable_event != nil
            if User.current.allowed_to?(:edit_delivery_date,project)
              livrable_event.destroy
            end
          end
        end

      end
      update_issue_event


    end

  end
end