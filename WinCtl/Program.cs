using ArgParseCS;
using System;

namespace WinCtl
{
    
    class Program
    {
        private ArgParse argParse;
        private readonly string[] args;
        public Program(string[] args)
        {
            DefineParams();
            this.args = args;
        }

        static void Main(string[] args)
        {
            Program program = new Program(args);
            program.Execute();
        }

        private void Execute()
        {
            try
            {
                argParse.Parse(args);
            }
            catch (ArgumentException e)
            {
                argParse.Usage();
                return;
            }
            OptionSet activeOptionSet = argParse.GetActiveOptionSet();
            Console.Out.WriteLine("Active optionset: " + activeOptionSet.Name);

            switch(activeOptionSet.Name)
            {
                case "Version command":
                    this.ShowVersion();
                    break;
            }

        }
        private void ShowVersion()
        {
            Console.Out.WriteLine(Constants.VERSION_NUMBER);
        }
        private void DefineParams()
        {
            argParse = new ArgParse {
                new OptionSet(Constants.OPTIONSET_FLIP_SCREEN)
                {
                    new Option("-fs", "--flip-screen", "Flips the screen 180 degrees.", true, true)
                },
                new OptionSet(Constants.OPTIONSET_VERSION) 
                {
                    new Option("-v", "--version", "Show version", true, false)
                }/*,
                new OptionSet("Analysis command") {
                    new Option("-i", "--input", "Specify the input folder path", true, true),
                    new Option("-o", "--output", "Specify the output folder path", true, true),
                    new Option("-t", "--trend", "Specify the trend option", false, false),
                },
                new OptionSet("Help command") {
                    new Option("-h", "--help", "Show help options", true, false),
                }*/
            };

        }
    }
}
