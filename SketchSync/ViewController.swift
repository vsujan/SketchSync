import UIKit
import SwiftyDropbox

class ViewController: UIViewController, FileListTableViewControllerDelegate {
    
    var file: ProjectFile!
    
    @IBOutlet var fileListView: UIView!
    
    var filelistTVC: FileListTableViewController!
    var fileViewer: FileViewController!
    
    var handleNetwork = NetworkHandler()
    let fileHandler = FileHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func uploadFileAction(sender: UIButton) {
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
        }
        if let client = Dropbox.authorizedClient { // if the client is authorized
            handleNetwork.uploadFile(client) { //call to a function to upload a file and as a return value check if update is complete
                uploadComplete in
                    print("upload complete")
            }
        }
    }
    
    @IBAction func listFilesAction(sender: UIButton) {
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
        }
        //list all the downloaded files and works in offline mode
        self.filelistTVC.files = fileHandler.listFilesFromLocalDirectory()
        self.filelistTVC.tableView.reloadData()
        
        //call to a function to list the files from the dropbox and as a return value gets an array of files from dropbox
        if let client = Dropbox.authorizedClient {
            handleNetwork.listFiles(client, files: self.filelistTVC.files) {
                files in
                    self.filelistTVC.files = files
                    self.filelistTVC.tableView.reloadData()
            }
        }
    }
    
    //segue to table view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fileListTVC" {
            filelistTVC = segue.destinationViewController as! FileListTableViewController
            filelistTVC.delegate = self
        }
    }
    
    //action when a cell is selected
    func actionForSelectedFile(selectedFile: ProjectFile, index: Int) {
        
        // open the file if already downloaded
        if selectedFile.isDownloaded {
            let request = fileHandler.openSelectedFile(selectedFile.docURL!)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let fileViewer = storyboard.instantiateViewControllerWithIdentifier("fileViewController") as! FileViewController
            navigationController?.pushViewController(fileViewer, animated: true)
            fileViewer.req = request
        } else { // download the file if not downloaded already
            if (Dropbox.authorizedClient == nil) {
                Dropbox.authorizeFromController(self)
            } else {
                print("User is already authorized!")
            }
            if let client = Dropbox.authorizedClient {
                fileHandler.downloadFileOfSelectedRow(selectedFile.name, pathOfFile: selectedFile.path_lower!, client: client) {
                    downloadComplete, fileURL in
                        self.filelistTVC.files[index].isDownloaded = downloadComplete // set the flag to download is true
                        self.filelistTVC.files[index].docURL = fileURL // set the local url of the file
                        self.filelistTVC.tableView.reloadData()
                }
            }
        }
        
    }
    
}
