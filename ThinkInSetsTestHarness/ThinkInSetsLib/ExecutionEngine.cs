using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ThinkInSetsLib
{
    public static class ExecutionEngine
    {
        public static void RunTest(IThinkInSetsTest test)
        {
            List<TimeSpan> executionTimes = new List<TimeSpan>();
            for (int executionCounter = 0; executionCounter < 5; executionCounter++)
            {
                Stopwatch clock = Stopwatch.StartNew();

                test.ExecuteTest();

                clock.Stop();
                executionTimes.Add(clock.Elapsed);

                Console.WriteLine($"Test {executionCounter + 1} completed in {clock.Elapsed.TotalMilliseconds:0.000} ms.");
            }
            executionTimes.RemoveMinAndMaxValues();
            double averageTimeInMilliseconds = executionTimes.Average(t => t.TotalMilliseconds);

            Console.WriteLine($"Test completed; average time = {averageTimeInMilliseconds:0.000} ms.");
        }
    }
}
