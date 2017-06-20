using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
                clock.Stop();
                executionTimes.Add(clock.Elapsed);
            }
            executionTimes.Sort((x, y) => x.CompareTo(y));
            executionTimes.RemoveAt(executionTimes.Count - 1);
            executionTimes.RemoveAt(0);
            double averageTimeInMilliseconds = executionTimes.Average(t => t.TotalMilliseconds);
        }
    }
}
