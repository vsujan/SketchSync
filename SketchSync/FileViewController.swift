import UIKit

class FileViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    var req: NSURLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if req != nil {
            self.webView.loadRequest(req!)
        }
    }
    
}
