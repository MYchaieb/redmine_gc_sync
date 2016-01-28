module UserPatchGoogleCalendarMail
	def self.included(base)
		base.class_eval do 

			unloadable

			safe_attributes :google_cal_mail
		end
	end
end