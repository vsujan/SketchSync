import Foundation
import SwiftyDropbox

class FileHandler {
    
    func listFilesFromLocalDirectory() -> [ProjectFile]{
        
        var file: ProjectFile!
        var files: [ProjectFile] = []
        
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) // path of the download directory as string
        let dir = dirs[0]
        let docURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first // path of the download directory as NSURL
        do {
            let fileList = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(dir) // contents of the directory
            for fileInList in fileList {
                file = ProjectFile(name: fileInList, path_lower: "", isDownloaded: true, docURL: (docURL?.URLByAppendingPathComponent(fileInList))! )
                files.append(file)
            }
        } catch let error as NSError {
        print(error)
        }
        return files
        
    }
    
    func downloadFileOfSelectedRow(nameOfFileToDownload: String, pathOfFile: String, client: DropboxClient, downloadComplete: (Bool, NSURL) -> Void) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // download a file
        let destination : (NSURL, NSHTTPURLResponse) -> NSURL = {
            temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            
            // generate a unique name for this file in case we've seen it before
            return directoryURL.URLByAppendingPathComponent(nameOfFileToDownload)
        }

        client.files.download(path: pathOfFile, destination: destination).response { response, error in
            if let (metadata, data) = response {
                print("*** Download file ***")
                print("Downloaded file name: \(metadata.name)")
                print("Downloaded file data: \(data.absoluteString)")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                downloadComplete(true, data)
            } else {
                print(error!)
            }
        }
    }
    
    // open a downloaded file
    func openSelectedFile (fileURL: NSURL) -> NSURLRequest {
        let fileRequest = NSURLRequest(URL: fileURL)
        return fileRequest
    }
    
}
