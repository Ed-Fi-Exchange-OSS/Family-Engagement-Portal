using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Console
{
    class Program
    {
        static void Main(string[] args)
        {
            System.Console.WriteLine("Executing Student1 Parent Portal Cron");

            var apiEndpointForSendingAlerts = ConfigurationManager.AppSettings["apiEndpointForSendingAlerts"];
            var client = new RestClient(apiEndpointForSendingAlerts);
            var request = new RestRequest(Method.GET);

            System.Console.WriteLine($"-> Calling endpoint: {apiEndpointForSendingAlerts}");
            var watch = System.Diagnostics.Stopwatch.StartNew();
            var response = client.Execute(request);
            watch.Stop();

            System.Console.WriteLine($"--> Status:{response.StatusDescription}, Content: {response.Content} in ({watch.ElapsedMilliseconds}ms)");

            if(response.StatusCode!=System.Net.HttpStatusCode.OK)
                Environment.Exit(-1);
#if DEBUG
            System.Console.WriteLine("Press any key to exit.");
            System.Console.ReadKey();
#endif


        }
    }
}
