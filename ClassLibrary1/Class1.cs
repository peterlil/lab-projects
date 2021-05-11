using System;

/*
 * 1. Install Dotfuscator Community
 *    https://docs.microsoft.com/en-us/visualstudio/ide/dotfuscator/install?view=vs-2019
 * 2. Find the path to dotfuscator.exe. On my computer: "c:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\Extensions\PreEmptiveSolutions\DotfuscatorCE\dotfuscator.exe" 
 *    
 */


namespace ClassLibrary1
{
    public class AdvancedMathHelpersFacade
    {
        public int GetNthPrime(int nth)
        {
            AdvancedMathHelpers helpers = new AdvancedMathHelpers();
            return helpers.GetNthPrime(nth);
        }
        
    }

    internal class AdvancedMathHelpers
    {
        public int GetNthPrime(int nth)
        {
            int i = 1;
            int counter = 0;
            bool isPrime = true;

            while (counter < nth)
            {
                for (int j = 2; j <= i / 2; j++)
                {
                    if (i % j == 0)
                    {
                        isPrime = false;
                        break;
                    }
                }

                if (isPrime)
                {
                    counter++;
                }

                i++;
            }
            // returns
            return counter;
        }
    }
}
