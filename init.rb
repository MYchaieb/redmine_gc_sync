require 'redmine'
require 'json'
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3
require_dependency 'livrable_date' 

require_dependency 'issuesPatch'
require_dependency 'userPatch'

require_dependency 'user_gc_mail'

require_dependency 'houre_patch'

ActiveSupport::Reloader.to_prepare do
	require_dependency 'issue'
  require_dependency 'user'
	Issue.send(:include, IssuePatchDeliveryDate)
  User.send(:include,UserPatchGoogleCalendarMail)
end

Redmine::Plugin.register :redmine_gc_sync do
  name 'Redmine Gc Sync plugin'
  author 'Chaieb Yassine'
  description 'This is a plugin for Redmine'
  version '1.0.0'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'


  project_module :issue_tracking do |map|
  	map.permission :view_delivery_date, {}
  	map.permission :edit_delivery_date, {}
  end

  permission :view_livrable_project, :livrable_project => :index

  settings :default => {}, :partial => 'settings/yassine_settings'

  project_module :module_livrable_project do
  	permission :view_livrable_project, :livrable_project => :index
  end

  if_proc = Proc.new{|project| project.enabled_module_names.include?('module_livrable_project')}

  menu :project_menu, 'TEST', {:controller => 'livrable_project', :action => 'index'}, :caption => :redmine_gc_sync, :last => true, :param => :project_id, :if => if_proc


end

