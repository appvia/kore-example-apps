using System;
using System.Net;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;

namespace NetCore.Docker.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;

        public IndexModel(ILogger<IndexModel> logger)
        {
            _logger = logger;
        }

        public static string GetHostName()
        {
          string hostName = Dns.GetHostName();
          return hostName;
        }

        public static string GetDotNetVersion()
        {
          string runtime = System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription;
          return runtime;
        }

        public void OnGet()
        {
          string hostName = GetHostName();
          string dotNetVersion = GetDotNetVersion();
          ViewData["HostName"] = hostName;
          ViewData["Runtime"] = dotNetVersion;
        }
    }
}
