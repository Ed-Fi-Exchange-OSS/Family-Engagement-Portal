Parent Portal provided by YesPrep and Student1 
============

This parent portal was made possible thanks to Yes Prep Public Schools and Student1.

Description
------------
The Parent Engagement Portal provides an easy-to-use view of student information, attendance, discipline, grades, and assessment scores with links to parent views in other applications. The Portal enables communication between members of the student’s “success team” by supporting text communications with automatic language translation.

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
Teacher:
   Email: fred.lloyd@toolwise.onmicrosoft.com
   Password: Teacher123
~~~

Setup
------------

We tried to make the setup and deploy of this web application as easy as possible.

### Prerequisites ###

* Install Visual Studio Community Edition (https://visualstudio.microsoft.com/downloads/)
* Install MsSQL Developer Edition (https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
* Install SQL Server Management Studio (https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
* Download and restore Ed-Fi ODS v3.1
  * Download 3.1 from here: https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Samples.Ods/3.1.1
* Download the code (https://github.com/Ed-Fi-Alliance/Ed-Fi-X-ParentPortal)
* Open code with Visual Studio Community Edition
* Compile

### Running the application for the first time ###

Before you begin make sure you have gone through all the Prerequisites listed above.

To run the Parent Portal we still need to execute some application specific scripts.


Open SQL Server Management Studio and run the following scripts in the order that they are listed to configure the Database.
Scripts are located at the following location "~/Student1.ParentPortal.Data/Scripts/edFi31/"
  * 1CreateParentPortalSupportingDatabaseSchema.sql
  * 2ODSExtensions.sql
  * 99SampleDataNeededForDemo.sql (For Demo Only)

You are now ready to run the application. 
Go back to Visual Studio Community Edition and press F5.

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

~~~
Teacher:
   Email: fred.lloyd@toolwise.onmicrosoft.com
   Password: Teacher123
~~~


Production Deployment Notes
------------

As mentioned before the main goal of this application was to make it as simple as possible to standup and deploy.

The main things needed to change for this application to run in production are:

* Authentication parameters for AzureAd:
    * In file app.config.js
		* instance: 'https://login.microsoftonline.com/',
		* tenant: '[Enter your tenant name here e.g. contoso.onmicrosoft.com]',
		* clientId: '[Enter your clientId here e.g. e9a5a8b6-8af7-4719-9821-0deef255f68e]',
	* In file Web.config -> AppSettings keys:
		* authentication.azure.tenant value = "[Enter your tenant name here e.g. contoso.onmicrosoft.com]"
		* authentication.azure.audience value = "[Enter your clientId here e.g. e9a5a8b6-8af7-4719-9821-0deef255f68e]" 
* Database Connection string located in the Web.config file.
* For alerts and emails update:
   * feedback.emails to contain the email that should receive the messages.
   * messaging.email.defaultFromEmail set to the email that will appear in the from field.
   * messaging.email.server set to your email provider server
   * messaging.email.user set to the user to send emails
   * messaging.email.pass set to the password to be able to send emails
* For translation services:
   * translation.Name set to the user or name of the service used
   * translation.Key set to the key provided by the service
* If using Azure Blob Storage for images set the azure.storage.connectionString.
* If using Azure Scalable SignalR update the Azure:SignalR:ConnectionString

## Legal Information

Copyright (c) 2019 Ed-Fi Alliance, LLC and contributors.

Licensed under the [Apache License, Version 2.0](LICENSE) (the "License").

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

See [NOTICES](NOTICES.md) for additional copyright and license notifications.
