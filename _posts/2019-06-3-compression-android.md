---
layout: post
title:  "How to create a zip in Xamarin Android"
date:   2019-06-03 22:02:00
categories: [post-2, android, xamarin, c#]
tags: [Android, Xamarin, C#, java, zip]
comments: false
---

This solution is specifically for Android using Xamarin because I am using the `Java.Util.Zip` Class. This solution can just as easily be ported to Java.

<!--more-->

<A href="#solution">Skip to the solution section below if you just want to see code.</A>

## Why I needed this functionality?  
I am working on building an Android tool to help troubleshoot problems on a device that isn't easily assecible. I was implementing a feature to gather important local files and folders then package them up and email them to interested parties. The packaging up of the files is important since many of the devices where the app will be used is on poor internet connections.  

## Different approaches to the problem
### The pure C# approach
Originally I tried looking for a generic C# solution that I could potentially make cross platform. However the `System.IO.Compression` API was a bit limited. For example I can easily compresses a directory but I have no control over what gets compressed in the folder i.e. if I want to skip over specific folders the api does not allow this.  

### The NuGet package approach
Then I attempted to look for a NuGet package that would simply zip a folder for me. That lead me to the possibility of using the 7z nuget but decided to hold off on going down that path because of lack of easy to find/read documentation.  

### The Android specific approach
Then I attempted to find an Android specific solution, in Java, which lead me to the `Java.Util.Zip` class. I found a nice example of it's usage to compress and decompress zips. The port to C# was pretty straight forward.  

I made some modifications like being able to skip folders as well as some refactoring for readability and file contingency issues since I am not guaranteed that the files I am compressing are not being written to as I am reading them to compress them.  

## Example usage of solution
Here is an example of a simple usage of the solution. Notice the destination of the zip can be anywhere. The last parameter can be an empty set if you don't want to exclude any folders.

{% highlight C# linenos %}
ZippingAround.Compress("/sdcard/foo/", "/sdcard/destination/foo.zip", new HashSet<string>{ "large-files-folder" });
{% endhighlight %}

## Solution ##
{% highlight C# linenos %}
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

using Java.Util.Zip;

namespace foo
{
   public class ZippingAround
   {
      public static void Compress(string from, string to, HashSet<string> excludeFolders)
      {
         if (File.Exists(to)) File.Delete(to);

         using (var filestream = new FileStream(to, FileMode.OpenOrCreate, FileAccess.Write))
         {
            using (var zipStream = new ZipOutputStream(filestream))
            {
               CompressDirectory(from, zipStream, excludeFolders);
               zipStream.Finish();
            }
         }
      }

      private static void CompressDirectory(string dir2zip, ZipOutputStream zipStream, HashSet<string> foldersToExclude, string parent = "")
      {
         if (!Directory.Exists(dir2zip)) throw new ArgumentException($"Directory given does not exists. [{dir2zip}]");

         var zipDir = new DirectoryInfo(dir2zip);

         foreach (var file in zipDir.GetFiles())
         {
            var relativePath = string.IsNullOrEmpty(parent) ? file.Name : $"{parent}/{file.Name}";
            AddFileToArchive(zipStream, relativePath, file.FullName);
         }

         var directories = from directory in zipDir.GetDirectories()
                           where !foldersToExclude.Contains(directory.Name)
                           select directory;

         foreach (var directory in directories)
         {
            var relativeParentPath = string.IsNullOrEmpty(parent) ? directory.Name : $"{parent}/{directory.Name}";
            CompressDirectory(directory.FullName, zipStream, foldersToExclude, relativeParentPath);
         }
      }

      private static void AddFileToArchive(ZipOutputStream zipStream, string relativePath, string fullPath)
      {
         var tempFileName = $"{fullPath}.{DateTime.UtcNow.Ticks}.temp";

         try
         {
            File.Copy(fullPath, tempFileName);

            zipStream.PutNextEntry(new ZipEntry(relativePath));
            byte[] bytes = File.ReadAllBytes(tempFileName);
            zipStream.Write(bytes, 0, bytes.Length);
            zipStream.CloseEntry();
         }
         catch (Exception ex)
         {
            Console.WriteLine($"Problem compressing {ex.Message}");
         }

         if (File.Exists(tempFileName)) File.Delete(tempFileName);
      }
   }
}
{% endhighlight %}



## Room for improvement  
This class could probably be improved by adding an ability to skip files and file extensions as well as directories.  

