class InsertchampsIssue < Redmine::Hook::ViewListener

	def view_issues_form_details_top(context = {})

		project = context[:project]

		tag = context[:form].text_field :delivery_date, :size => 10 
		# tag =  calendar_for('issue_delivery_date')

		if User.current.allowed_to?(:edit_delivery_date, project)
			return content_tag(:p, tag)
		else
			return nil
		end

		
	end

	def view_issues_form_details_bottom(context = {})
		script = "<script>
				//<![CDATA[
				$(function() { $('#issue_delivery_date').datepicker(datepickerOptions); });
				
				//]]>
				</script>"

		return script

	end


	def view_issues_show_details_bottom(context = {})
		date = ''

		if context[:issue].delivery_date != nil

			date = format_date(context[:issue].delivery_date)
		end	

		hi = ''

		if context[:issue].heure_delivery != nil
			time = context[:issue].heure_delivery
			hi = time

		end


		tag = l(:field_delivery_date)+': ' + date +"  | "+ hi

		if User.current.allowed_to?(:view_delivery_date, context[:project])
			return content_tag(:p, tag)
		else
			return nil
		end

	end


end