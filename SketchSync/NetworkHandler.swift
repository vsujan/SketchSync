import Foundation
import SwiftyDropbox

class NetworkHandler {
    
    var tempFiles: [Files.FileMetadata] = []
    
    func uploadFile (client: DropboxClient, uploadComplete: (Bool) -> Void  ) {
        
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let fileData = "this is the new file!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            client.files.upload(path: "/myProject/myfile1.txt", body: fileData!).response {
                response, error in
                    if let metadata = response {
                        print("Uploaded file name: \(metadata.name)")
                        print("Uploaded file revision: \(metadata.rev)")
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    }
                 uploadComplete(true)
            }
    }
    
    func listFiles(client: DropboxClient, files: [ProjectFile], completionHandler: ([ProjectFile]) -> Void){
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        client.files.listFolder(path: "").response { (mainResponse, error) in
            var file: ProjectFile!
            var newFiles: [ProjectFile] = []
            if let mainResult = mainResponse {
                let docURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
                for mainEntry in mainResult.entries {
                    var path = ""
                    client.files.getMetadata(path: mainEntry.pathLower).response { response, error in
                        if let metadata = response {
                            if let file = metadata as? Files.FileMetadata {
                                print("This is a file with path: \(file.pathLower)")
                                self.tempFiles.append(file)
                                print(self.tempFiles)
                            } else if let folder = metadata as? Files.FolderMetadata {
                                print("This is a folder with path: \(folder.pathLower)")
                                self.iterateFolder(client, folder: folder) //{ file in
                            }
                        }
                        if (self.tempFiles.count > 0) {
                            print("here")
                        }
                    }
                }
            }
            
        }
        
    }
    
    func iterateFolder (client: DropboxClient, folder: Files.FolderMetadata) {
        var pathOfFolder = folder.pathLower
        client.files.listFolder(path: pathOfFolder).response { (response, error) in
            if let result = response {
                for entry in result.entries {
                    client.files.getMetadata(path: entry.pathLower).response { response, error in
                        if let metadata = response {
                            if let file = metadata as? Files.FileMetadata {
                                print("This is a file with path: \(file.pathLower)")
                                self.tempFiles.append(file)
                            } else if let folder = metadata as? Files.FolderMetadata {
                                print("This is a folder with path: \(folder.pathLower)")
                                self.iterateFolder(client, folder: folder)
                            }
                        }
                        if (self.tempFiles.count > 0) {
                            print("here")
                        }
                    }
                }
            }
        }
    }
    
}