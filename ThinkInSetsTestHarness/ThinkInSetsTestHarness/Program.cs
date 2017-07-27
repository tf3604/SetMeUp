///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2017, Brian Hansen(brian at tf3604.com).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using ThinkInSetsLib;

namespace ThinkInSetsTestHarness
{
    class Program
    {
        static void Main(string[] args)
        {
            bool runAllTests = args.Length == 0;

            try
            {
                if (runAllTests ||
                    ArgsMatchPattern(args, "^.*singleton*.$") ||
                    ArgsMatchPattern(args, "^060$"))
                {
                    Console.WriteLine("*** Singleton Test (#60)");
                    FileSystemSingletonInsertTest singletonTest = new FileSystemSingletonInsertTest(
                        Properties.Settings.Default.FileSystemPath,
                        Properties.Settings.Default.FileCount,
                        Properties.Settings.Default.SqlInstanceName,
                        Properties.Settings.Default.SqlDataBaseName);

                    ExecutionEngine.RunTest(singletonTest);
                    Console.WriteLine();
                }

                if (runAllTests ||
                    ArgsMatchPattern(args, "^.*bulk.*copy.*$") ||
                    ArgsMatchPattern(args, "^061$"))
                {
                    Console.WriteLine("*** Bulk Copy Test (#61)");
                    FileSystemBulkCopyTest bulkCopyTest = new FileSystemBulkCopyTest(
                        Properties.Settings.Default.FileSystemPath,
                        Properties.Settings.Default.FileCount,
                        Properties.Settings.Default.SqlInstanceName,
                        Properties.Settings.Default.SqlDataBaseName);

                    ExecutionEngine.RunTest(bulkCopyTest);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"{ex.ToString()}");
            }
        }
        private static bool ArgsMatchPattern(string[] args, string pattern)
        {
            foreach (string arg in args)
            {
                string argLower = arg.ToLowerInvariant();
                if (Regex.IsMatch(argLower, pattern))
                {
                    return true;
                }
            }

            return false;
        }
    }
}
