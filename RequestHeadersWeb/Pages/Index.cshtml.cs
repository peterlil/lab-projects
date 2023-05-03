using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using RequestHeadersWeb.Models;
using Microsoft.Extensions.Primitives;

namespace RequestHeadersWeb.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;
        public List<Header>? Headers { get; set; }

        public IndexModel(ILogger<IndexModel> logger)
        {
            _logger = logger;
        }

        public void OnGet()
        {
            Headers = new List<Header>();

            foreach (KeyValuePair<string, StringValues> header in this.Request.Headers)
            {
                Header newHeader = new Header();
                newHeader.Name = header.Key;
                foreach (string? value in header.Value)
                {
                    newHeader.Values.Add(value!);
                }
                Headers.Add(newHeader);
            }
        }
    }
}
