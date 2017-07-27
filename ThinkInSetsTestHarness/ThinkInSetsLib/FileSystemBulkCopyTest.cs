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
    public class FileSystemBulkCopyTest : FileSystemTest, IThinkInSetsTest
    {
        public FileSystemBulkCopyTest(
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

            using (SqlBulkCopy bulkCopy = new SqlBulkCopy(_connection, SqlBulkCopyOptions.TableLock | SqlBulkCopyOptions.UseInternalTransaction, null))
            {
                bulkCopy.BulkCopyTimeout = 300;
                bulkCopy.ColumnMappings.Clear();
                bulkCopy.ColumnMappings.Add("FilePath", "FilePath");
                bulkCopy.ColumnMappings.Add("LastWriteTime", "LastWriteTime");
                bulkCopy.DestinationTableName = "stage.DataFile";
                using (DataTable fileTable = CreateFileListDataTable())
                {
                    bulkCopy.WriteToServer(fileTable);
                }
            }
        }

        private DataTable CreateFileListDataTable()
        {
            DataTable table = new DataTable();
            try
            {
                table.Columns.Add("FilePath");
                table.Columns.Add("LastWriteTime");

                foreach (FileInfo file in _files)
                {
                    DataRow row = table.NewRow();
                    row["FilePath"] = file.FullName;
                    row["LastWriteTime"] = file.LastWriteTime;
                    table.Rows.Add(row);
                }

                return table;
            }
            catch
            {
                if (table != null)
                {
                    table.Dispose();
                    table = null;
                }
                throw;
            }
        }
    }
}

