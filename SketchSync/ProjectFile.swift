import Foundation

class ProjectFile {
    
    var name: String!
    var path_lower: String?
    var docURL: NSURL?
    var isDownloaded: Bool
    
    init(name: String, path_lower: String, isDownloaded: Bool, docURL: NSURL) {
        self.name = name
        self.path_lower = path_lower // path of the file in dropbox
        self.isDownloaded = isDownloaded
        self.docURL = docURL // local path of the file
    }
    
}