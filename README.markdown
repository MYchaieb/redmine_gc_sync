Redmine GC sync 
================

This Redmine plugin have essencialy 3 roles: 

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

* Go to ``` Administration >  Plugins > Redmine Gc Sync plugin : Configure ``` and follow the steps. 

### Obtain a Client ID and Secret  
 1. Go to the [GOOGLE DEVELOPPERS CONSOLE](https://console.developers.google.com/).
 2. Select a project, or create a new one.
 3. In the sidebar on the left, expand APIs & auth. Next, click APIs. In the list of APIs, make sure the status is ON for the Calendar API
 4. In the sidebar on the left, select Credentials.
 5. In either case, you end up on the Credentials page and can create your project's credentials from here.
 6. If you haven't done so already, create your OAuth 2.0 credentials by clicking Create new Client ID under the OAuth heading. Next, look for your application's client ID and client secret in the relevant table.

### Find your calendar ID 
 1. Visit [Google Calendar](https://www.google.com/calendar/) in your web browser.
 2. In the calendar list on the left, click the down-arrow button next to the appropriate calendar, then select Calendar settings.
 3. In the Calendar Address section, locate the Calendar ID listed next to the XML, ICAL and HTML buttons.
 4. Copy the Calendar ID.