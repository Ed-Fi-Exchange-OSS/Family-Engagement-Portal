Parent Portal provided by Student1, YesPrep and MSDF
============

This parent portal was made possible thanks to the Student1 and the MSDF foundations.

Live Demo
------------

URL: http://parentportal.toolwise.net/

**Credentials:**

~~~
Parent:
   Email: perry.savage@toolwise.onmicrosoft.com
   Password: Parent123
~~~

~~~
Teacher:
   Email: alexander.kim@toolwise.onmicrosoft.com
   Password: Teacher123
~~~

~~~
Teacher for 3.1:
   Email: fred.lloyd@toolwise.onmicrosoft.com
   Password: Teacher123
~~~

Setup
------------

We tried to make the setup and deploy of this web application as easy as possible.

### Prerequisites ###

* Install Visual Studio Community Edition
* Install MsSQL Developer Edition
* Download and restore Ed-Fi ODS v2.5
* Download the code
* Open code with VS
* Compile

### Running the application for the first time ###

Before you begin make sure you have gone through all the Prerequisites listed above.

Make sure you change the connection string parameters to point to your database.


Test credentials
------------

Ensure that your application is running on: http://localhost/Student1.ParentPortal.Web/

For Azure Ad testing use:
**Credentials:**

~~~
Parent:
   Email: perry.savage@toolwise.onmicrosoft.com
   Password: Parent123
~~~

~~~
Teacher:
   Email: alexander.kim@toolwise.onmicrosoft.com
   Password: Teacher123
~~~


Production Deployment Notes
------------

As mentioned before the main goal of this application was to make it as simple as possible to standup and deploy.

The main things needed to change for this application to run in production are:

* Authentication parameters for AzureAd:
    * In file app.config.authentication.azure.js
		* instance: 'https://login.microsoftonline.com/',
		* tenant: '[Enter your tenant name here e.g. contoso.onmicrosoft.com]',
		* clientId: '[Enter your clientId here e.g. e9a5a8b6-8af7-4719-9821-0deef255f68e]',
	* In file Web.config -> AppSettings keys:
		* authentication.azure.tenant value = "[Enter your tenant name here e.g. contoso.onmicrosoft.com]"
		* authentication.azure.audience value = "[Enter your clientId here e.g. e9a5a8b6-8af7-4719-9821-0deef255f68e]" 
* Database Connection string located in the Web.config file.
* Parent Portal API rootApiUri located in the app.config.js file.
