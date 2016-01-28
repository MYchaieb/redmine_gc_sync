class InsertchampsHeureIssue < Redmine::Hook::ViewListener

	def view_issues_form_details_top(context = {})

		project = context[:project]
		issue = context[:issue]

		value = issue.heure_delivery

		tag = context[:form].time_field :heure_delivery, :size => 8, :placeholder => "hh:mm", :value => value

		if User.current.allowed_to?(:edit_delivery_date, project)
			return content_tag(:p, tag)
		else
			return nil
		end

		
	end

end