using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ThinkInSetsLib
{
    public static class ExtensionMethods
    {
        public static void RemoveMinAndMaxValues<T>(this List<T> list)
        {
            if (list.Count <= 2)
            {
                list.Clear();
            }
            else
            {
                T minValue = list.Min();
                list.Remove(minValue);

                T maxValue = list.Max();
                list.Remove(maxValue);
            }
        }
    }
}
