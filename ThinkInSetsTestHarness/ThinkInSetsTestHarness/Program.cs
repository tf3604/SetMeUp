using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ThinkInSetsLib;

namespace ThinkInSetsTestHarness
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Console.WriteLine("*** Singleton Test (#60)");
                //FileSystemSingletonInsertTest singletonTest = new FileSystemSingletonInsertTest(
                //    Properties.Settings.Default.FileSystemPath,
                //    Properties.Settings.Default.FileCount,
                //    Properties.Settings.Default.SqlInstanceName,
                //    Properties.Settings.Default.SqlDataBaseName);

                //ExecutionEngine.RunTest(singletonTest);

                Console.WriteLine();
                Console.WriteLine("*** Bulk Copy Test (#61)");
                FileSystemBulkCopyTest bulkCopyTest = new FileSystemBulkCopyTest(
                    Properties.Settings.Default.FileSystemPath,
                    Properties.Settings.Default.FileCount,
                    Properties.Settings.Default.SqlInstanceName,
                    Properties.Settings.Default.SqlDataBaseName);

                ExecutionEngine.RunTest(bulkCopyTest);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"{ex.ToString()}");
            }
        }
    }
}
