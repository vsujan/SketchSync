import UIKit

class FileNameCell: UITableViewCell {

    @IBOutlet var fileName: UILabel!
    
    var isDownloadedCell: Bool = false {
        didSet {
            if isDownloadedCell {
                self.accessoryType = UITableViewCellAccessoryType.Checkmark // set checkmark if the file is already downloaded
            } else {
                self.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
