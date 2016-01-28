Redmine GC sync 
================

This Redmine plugin have essencialy 3 role: 

* Introduce the concept of project delivery date: For a project that have an end and will be delivered for client, you can add this plugin as a module and configure the date etc ... and you'll have an event for that on your Google Calendar. 

* Introduce the concept of Issue delivery date - hour : For a project that contain a lot of issue to deliver for a client or a manager or whatever. you can configure a data and an hour of delivery. You'll have an event on your calendar with that date. 

* Synchronize redmine Issues ( that obey the filters rule ) with your google calendar ( Issue must have a start date and a due date ). The plugin also add a field  on users account "google calendar mail", this field can be filled only by admin, so he can be invited to the event ( it will be shown on his google calendar ) if he is assigned to the issue. ( if the issue is assigned to a group , every memeber will be invited, if he have a google calendar mail)

================
## Installation - Linux
* Clone this repository into ```{REDMINE_ROOT}/plugins/```

* Install dependencies and migrate database
	```console
	cd redmine/
	bundle install
	RAILS_ENV=production rake redmine:plugins:migrate
	```
* Restart your Redmine web server 
	```console 
	service apache2 restart 
	```

## Plugin Configuration

