import UIKit

class FileListTableViewController: UITableViewController {

    var files: [ProjectFile] = []
    
    //delegate to this VC
    var delegate: FileListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filelist", forIndexPath: indexPath) as! FileNameCell
        cell.fileName.text = files[indexPath.row].name
        cell.isDownloadedCell = files[indexPath.row].isDownloaded
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.actionForSelectedFile(files[indexPath.row], index: indexPath.row)
    }
    
}

//call this function when a file is selected
protocol FileListTableViewControllerDelegate {
    func actionForSelectedFile(selectedFile: ProjectFile, index: Int)
}
