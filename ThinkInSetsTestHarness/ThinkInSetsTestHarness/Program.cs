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
            List<TimeSpan> executionTimes = new List<TimeSpan>();
            for (int executionCounter = 0; executionCounter < 5; executionCounter++)
            {
                Stopwatch clock = Stopwatch.StartNew();
                // Execute test
                // ...
                clock.Stop();
                executionTimes.Add(clock.Elapsed);
            }
            executionTimes.RemoveMinAndMaxValues();
            double averageTimeInMilliseconds = executionTimes.Average(t => t.TotalMilliseconds);

            Console.WriteLine($"Test completed; average time = {averageTimeInMilliseconds:0.000} ms.");
        }
    }
}
