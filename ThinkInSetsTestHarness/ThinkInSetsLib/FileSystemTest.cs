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
            List<FileInfo> files = new List<FileInfo>();
            GetAllFiles(files, rootDir, maxFileCount);
            _files = files.Take(maxFileCount).ToList();
            Console.WriteLine($"Inserting {_files.Count} files.");
        }

        private void GetAllFiles(List<FileInfo> files, DirectoryInfo dir, int maxFileCount)
        {
            try
            {
                FileInfo[] dirFiles = dir.GetFiles();
                files.AddRange(dirFiles);
                if (files.Count > maxFileCount)
                {
                    return;
                }
            }
            catch (Exception)
            {
                // Swallow it.
            }

            try
            {
                DirectoryInfo[] subDirs = dir.GetDirectories();
                foreach (DirectoryInfo subDir in subDirs)
                {
                    try
                    {
                        GetAllFiles(files, subDir, maxFileCount);
                        if (files.Count > maxFileCount)
                        {
                            return;
                        }
                    }
                    catch (Exception)
                    {
                        // Swallow it
                    }
                }
            }
            catch(Exception)
            {
                // Swallow it
            }

            return;
        }
    }
}
