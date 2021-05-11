using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

// Hej Vi testade zippa upp en fil 3,7 MB fil med 696 underobject (mappar och filer) på en FS32_v2 med accelerated networking. Det tog 40s. Samma fil på en NV12 utan acc.net tog 30s.

namespace multi_threaded_unzip
{
    class Program
    {
        static void Main(string[] args)
        {   
            Console.WriteLine("Hello World!");
        }
    }

    class FileGenerator
    {
        private int fileCountPerFolder = 100;
        private int folderCount = 100;
        private int foldersPerLevel = 12;
        private string sampleFileFullName = @"c:\l\dl\example_1.json";
        private string sampleFileContent = "";

        private string SampleFileFullName { get => sampleFileFullName; set => sampleFileFullName = value; }

        private int FoldersPerLevel { get => foldersPerLevel; set => foldersPerLevel = value; }

        private int FolderCount { get => folderCount; set => folderCount = value; }

        private int FileCountPerFolder { get => fileCountPerFolder; set => fileCountPerFolder = value; }

        public FileGenerator(int folderCount, int fileCountPerFolder, string sampleFileFullName)
        {
            this.FolderCount = folderCount;
            this.FileCountPerFolder = fileCountPerFolder;
        }

        async public Task GenerateFiles()
        {
            string rootFolderFullName = $"{Path.GetTempPath()}mt-unzip";
            string currentFolderFullName = rootFolderFullName;
            int fileCount = 0;
            int[] folderLevelStatus = new int[10];
            int currentLevel = 0;

            int noFilesToBeCreated = fileCountPerFolder * folderCount;
            var taskList = new List<Task>();

            // Delete the temp directory if it exists
            if (Directory.Exists(rootFolderFullName))
            {
                Console.WriteLine($"Deleting the existing directory ({rootFolderFullName}) and all its content.");
                Directory.Delete(rootFolderFullName, true);
            }

            // Load the sample file
            sampleFileContent = await File.ReadAllTextAsync(sampleFileFullName);

            // Create the root folder
            if (!Directory.Exists(currentFolderFullName))
            {
                Console.WriteLine($"Creating {currentFolderFullName}.");
                Directory.CreateDirectory(currentFolderFullName);
            }

            folderLevelStatus[currentLevel] = 0;
            do
            {
                for(int ifld = 0; ifld < foldersPerLevel; ifld++)
                {
                    // Create a subfolder with files in.
                    string ifldName = $"{rootFolderFullName}{Path.DirectorySeparatorChar}fld{ifld}";
                    Directory.CreateDirectory(ifldName);

                    taskList.Add(CreateFilesAsync(ifldName));
                    fileCount += fileCountPerFolder;

                    if(fileCount >= noFilesToBeCreated )
                    {
                        break;
                    }
                    
                }

                currentLevel++; 
            } while (fileCount <= noFilesToBeCreated);

            Task.WaitAll(taskList.ToArray());
        }

        async Task CreateFilesAsync(string folderFullName)
        {
            for (int i = 0; i < fileCountPerFolder; i++)
            {
                using (StreamWriter sw = new StreamWriter($"{folderFullName}file{i}.txt"))
                {
                    await sw.WriteAsync(sampleFileContent);
                }
            }
        }
    }
}
