Parent Portal Console App to Trigger Alerts
============

This project is a console application that calls an API endpoint to schedule the execution of alerts. It should be configured in a Azure Web Job or in a Windows server task scheduler.

Notes and Setup
------------
1. Compile in Release mode.
2. Update the Student1.ParentPortal.Console.exe.config -> appSettings -> apiEndpointForSendingAlerts to point to your API.
3. Create Zip with all files in ~/bin/release/*.*
4. Upload to Azure App Services -> app -> settings -> WebJobs and set the schedule to 0 */30 * * * * (Every 30 mins)

**Notes: Make sure you update the apiEndpointForSendingAlerts in the app.config**