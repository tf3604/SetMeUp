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

