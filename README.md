# iOS - Mobile Services - StorageDemo
This is a storage sample which makes use of WIndows Azure Mobile Services and Windows Azure Table and Blob Storage.  Mobile Services uses SQL Database for it's normal data storage so we have to do a bit of additional work in order to access Table and Blob Storage.  This sample was built using XCode, the iOS Framework, and the iOS Mobile Services SDK.

Below you will find requirements and deployment instructions.

## Requirements
* OSX - This sample was built on OSX Lion (10.7.4) but should work with more current releases of OSX.
* XCode - This sample was built with XCode 4.4 and requires at least XCode 4.0 due to use of storyboards and ARC.
* Windows Azure Account - Needed to create and run the Mobile Service as well as to create a Storage account.  [Sign up for a free trial](https://www.windowsazure.com/en-us/pricing/free-trial/).

## Source Code Folders
* /source/end - This contains code for the application with Mobile Services and requires client side changes noted below.
* /source/scripts - This contains copies of the server side scripts and requires script changes noted below.

## Additional Resources
I've released two blog posts which walks through the code for this sample.  The [first deals with the server side scripts](http://chrisrisner.com/Mobile-Services-and-Windows-Azure-Storage) and talks about how to connect Mobile Services to Storage.  The [second talks about the iOS Client](http://chrisrisner.com/iOS-and-Mobile-Services-and-Windows-Azure-Storage) and how to connect that to the Mobile Service.

#Setting up your Mobile Service
After creating your Mobile Service in the Windows Azure Portal, you'll need to create tables named "Tables", "TableRows", "BlobContainers", and "BlobBlobs".  After createing these tables, copy the appropriate scripts over.

#Client Application Changes
In order to run the client applicaiton, you'll need to change a few settings in your application.  After opening the source code in Xcode, open the StorageService.m file.  Find the init method and change the "mobileserviceurl" and "applicationkey" to match the values from the Mobile Service you've created.

#Script Changes
Inside of each of the scripts there are variables set for the Storage account name and key.  You'll need to copy these values from your storage account and replace the "accountname" and "accountkey" strings.

## Contact

For additional questions or feedback, please contact the [team](mailto:chrisner@microsoft.com).
