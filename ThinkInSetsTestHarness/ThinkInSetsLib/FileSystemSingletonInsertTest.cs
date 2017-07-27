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
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ThinkInSetsLib
{
    public class FileSystemSingletonInsertTest : FileSystemTest, IThinkInSetsTest
    {
        public FileSystemSingletonInsertTest(
            string rootDirName,
            int maxFileCount,
            string sqlInstanceName,
            string sqlDatabaseName)
            : base(sqlInstanceName, sqlDatabaseName)
        {
            ReadFileInformation(rootDirName, maxFileCount);
        }

        public void ExecuteTest()
        {
            string sql = @"truncate table stage.DataFile;";
            using (SqlCommand command = new SqlCommand(sql, _connection))
            {
                command.ExecuteNonQuery();
            }

            sql = "insert stage.DataFile (FilePath, LastWriteTime) values (@FilePath, @LastWriteTime);";
            foreach (FileInfo file in _files)
            {
                using (SqlCommand command = new SqlCommand(sql, _connection))
                {
                    SqlParameter filePathParameter = new SqlParameter("FilePath", file.FullName);
                    command.Parameters.Add(filePathParameter);

                    SqlParameter writeTimeParameter = new SqlParameter("LastWriteTime", file.LastWriteTime);
                    writeTimeParameter.SqlDbType = SqlDbType.DateTime2;
                    command.Parameters.Add(writeTimeParameter);

                    command.ExecuteNonQuery();
                }
            }
        }
    }
}
