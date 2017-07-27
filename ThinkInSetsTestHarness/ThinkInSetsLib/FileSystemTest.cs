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
