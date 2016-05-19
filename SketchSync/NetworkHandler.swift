import Foundation
import SwiftyDropbox

class NetworkHandler {
    
    class func uploadFile (client: DropboxClient, uploadComplete: (Bool) -> Void  ) {
        
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let fileData = "jojolappa!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            client.files.upload(path: "/newfile.txt", body: fileData!).response {
                response, error in
                    if let metadata = response {
                        print("Uploaded file name: \(metadata.name)")
                        print("Uploaded file revision: \(metadata.rev)")
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        //                // Get file (or folder) metadata
                        //                client.files.getMetadata(path: "/mountain.txt").response {
                        //                    response, error in
                        //                    if let metadata = response {
                        //                        print("Name: \(metadata.name)")
                        //                        if let file = metadata as? Files.FileMetadata {
                        //                        print("This is a file.")
                        //                        print("File size: \(file.size)")
                        //                        } else if let folder = metadata as? Files.FolderMetadata {
                        //                        print("This is a folder.")
                        //                        }
                        //                    } else {
                        //                    print(error!)
                        //                    }
                        //                }
                    }
                 uploadComplete(true)
            }
        
    }
    
    class func listFiles(client: DropboxClient, files: [ProjectFile], completionHandler: ([ProjectFile]) -> Void){
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        client.files.listFolder(path: "").response {
            response, error in
                var file: ProjectFile!
                var newFiles: [ProjectFile] = []
                if let result = response {
                    let docURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first // path to the local directory where the file resides
                     for entry in result.entries {
                        var isDownloaded = false
                        if files.count == 0 { // if no file is downloaded, all files from dropbox is added to the newFiles array
                            file = ProjectFile(name: entry.name, path_lower: entry.pathLower, isDownloaded: isDownloaded, docURL: (docURL?.URLByAppendingPathComponent(entry.name))! )
                            newFiles.append(file)
                        } else {
                            for fileInList in files {
                                if (entry.name == fileInList.name) { // if file is already downloaded
                                    isDownloaded = true
                                    break
                                } else {
                                    isDownloaded = false
                                }
                            }
                            file = ProjectFile(name: entry.name, path_lower: entry.pathLower, isDownloaded: isDownloaded, docURL: (docURL?.URLByAppendingPathComponent(entry.name))! )
                            newFiles.append(file)
                        }
                    }
                    completionHandler(newFiles)
                } else {
                    print(error!)
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
    }
    
}