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
    public abstract class FileSystemTest
    {
        protected List<FileInfo> _files;
        protected SqlConnection _connection;

        public FileSystemTest(string sqlInstanceName, string sqlDatabaseName)
        {
            if (string.IsNullOrEmpty(sqlInstanceName))
            {
                throw new ArgumentNullException(nameof(sqlInstanceName));
            }
            if (string.IsNullOrEmpty(sqlDatabaseName))
            {
                throw new ArgumentNullException(nameof(sqlDatabaseName));
            }

            SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder();
            sb.DataSource = sqlInstanceName;
            sb.InitialCatalog = sqlDatabaseName;
            sb.IntegratedSecurity = true;

            _connection = new SqlConnection(sb.ToString());
            _connection.Open();
        }

        protected void ReadFileInformation(string rootDirName, int maxFileCount)
        {
            DirectoryInfo rootDir = new DirectoryInfo(rootDirName);
            FileInfo[] files = rootDir.GetFiles("*", SearchOption.AllDirectories);
            _files = files.Take(maxFileCount).ToList();
        }
    }
}
