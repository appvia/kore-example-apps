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

        public void OnGet()
        {
          string hostName = Dns.GetHostName();
          string runtime = System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription;
          ViewData["HostName"] = hostName;
          ViewData["Runtime"] = runtime;
        }
    }
}
