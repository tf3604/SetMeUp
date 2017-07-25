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
