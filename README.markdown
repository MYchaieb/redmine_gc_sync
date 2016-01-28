Redmine GC sync 
================

This Redmine plugin have essencialy 3 roles: 

* Introduce the concept of project delivery date: For a project that have an end and will be delivered for client, you can add this plugin as a module and configure the date etc ... and you'll have an event for that on your Google Calendar. 

* Introduce the concept of Issue delivery date - hour : For a project that contain a lot of issue to deliver for a client or a manager or whatever. you can configure a data and an hour of delivery. You'll have an event on your calendar with that date. 

* Synchronize redmine Issues ( that obey the filters rule ) with your google calendar ( Issue must have a start date and a due date ). The plugin also add a field  on users account "google calendar mail", this field can be filled only by admin, so he can be invited to the event ( it will be shown on his google calendar ) if he is assigned to the issue. ( if the issue is assigned to a group , every memeber will be invited, if he have a google calendar mail)

================
## Installation
* Clone this repository into ```{REDMINE_ROOT}/plugins/```

	``` git clone https://github.com/MYchaieb/redmine_gc_sync.git ```

* Install dependencies and migrate database
	```console
	cd redmine/
	bundle install
	rake redmine:plugins:migrate RAILS_ENV=production
	```
* Restart your Redmine web server 
	```console 
	service apache2 restart 
	```

## Plugin Configuration

Go to ``` Administration >  Plugins > Redmine Gc Sync plugin : Configure ``` and follow the steps. 

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

 # The Plugin as a module 

 * One you finished the plugin configuration, you can manage the module permission from ```Administration > Roles and permissions ```

 * Add the module to the project 

 So as an example: I added the module to a project and i created the event as shown below in the picture :

 ![image](https://cloud.githubusercontent.com/assets/7374923/12647767/265ec59a-c5d7-11e5-9238-8f5a52c6e313.png)

 and then i want to my google calendar : I find this : 

 ![image](https://cloud.githubusercontent.com/assets/7374923/12647911/d92ccdfc-c5d7-11e5-8ea7-0b09929eeeb5.png)


 # The plugin as a patch 

 The plugin add the two field for each issue ( you can manage the permission for view and edit these field from admin pannel)

 See example below 
 ![patch issue](https://cloud.githubusercontent.com/assets/7374923/12648477/720e758c-c5da-11e5-8947-a3ba458ceff6.png)

 When you click on submit the evnt is created on the calendar : 

 ![cerrrf](https://cloud.githubusercontent.com/assets/7374923/12648522/b21be7cc-c5da-11e5-9c5c-3f760b5b7288.png)

 Title of the event will include  ```[Super project name] + issue subject + #issue id```

 Note : The event Title in module ( if it is set ) is used as a prefix for this king of event creation. 
 so the title of the event will be like : ``` Event Title +  [Super project name] + issue subject + #issue id```


 The plugin add a google calendar field : go ```Administration > Users > select a user``` 
 This field will be used to invite assignee on the next section. 

![gbfbgfbfgbf](https://cloud.githubusercontent.com/assets/7374923/12650204/33f42456-c5e2-11e5-8736-5af6b307ae57.png)

 # The plugin as a sync 

 After the configuration of the plugin, a filter part will appear : 

 ![settt](https://cloud.githubusercontent.com/assets/7374923/12648860/2fbfd3ea-c5dc-11e5-9461-8c87704750df.png)

 Note: if you don't select anything, nothing will be synchronized. 

 Note: Only issue having start date and  due date will be synchronized. 

 Let's go to out TEST PLUGIN issue. 

 and add a due date then save the issue : 


![dd](https://cloud.githubusercontent.com/assets/7374923/12648962/ba9128b6-c5dc-11e5-80f0-ce6ddae07eae.png)

Let's take a look on the calendar : 

![bgf](https://cloud.githubusercontent.com/assets/7374923/12649151/99d5d0bc-c5dd-11e5-8009-8e071d51fbed.png)

We find the event of the issue 
Note : Title of the event will include  ```[Super project name] + [ if exist : [ sub project ] + [ sub sub project ] + [etc ] ]+ issue subject + #issue id```

Note: I've created a rake task to run just one time to synchronize all issues that repect the filter rule you configured 

run this on the redmine root 

	``` rake gc_sync_tasks:exec RAILS_ENV="production" ```

![ter](https://cloud.githubusercontent.com/assets/7374923/12649555/5e48cab6-c5df-11e5-8ccb-2dfee20c9139.png)



Also, if you want to delelte all the synchornized Issues 

run this on the redmine root 

	``` rake delete_gc:exec RAILS_ENV="production" ```

![sssss](https://cloud.githubusercontent.com/assets/7374923/12649646/c3b5c3ea-c5df-11e5-9dd6-8c2521de2c92.png)


## Uninstallation

	``` rake redmine:plugins:migrate NAME=redmine_gc_sync VERSION=0 RAILS_ENV=production ```

