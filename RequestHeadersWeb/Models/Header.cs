using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace RequestHeadersWeb.Models
{
    public class Header
    {
        public string Name { get; set; }
        public List<string> Values { get; set; }
        [Display(Name = "Headers")]
        public string ValuesCombinedHTML
        {
            get
            {
                string result= string.Empty;
                for(int i = 0; i < Values.Count; i++)
                {
                    if(i>0)
                    {
                        result += string.Format("<br>{0}", Values[i]);
                    }
                    else
                    {
                        result += Values[i];
                    }
                }
                return result;
            }
        }
        public Header()
        {
            Values = new List<string>();
            Name="";
        }
    }
    
}
