
import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var delegateView = SettingsView(delegate: self)
    
    
//    static let notificationName = Notification.Name("myNotificationName")


    override func loadView() {
        super.loadView()
        
        view = delegateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("DocumentsViewController().isMySwitcher - ", DocumentsViewController().isMySwitcher)
    }
    
}

extension SettingsViewController: SettingsViewDelegate {
    func sorted(_ sender: UISwitch) {
        
        

        
        if sender.isOn {
            DocumentsViewController().isMySwitcher = true
            
//            mySwitch = true
            print("on")
        } else {
            DocumentsViewController().isMySwitcher = false
            print("off")
        }
        NotificationCenter.default.post(name: NSNotification.Name("default"),
                                        object: self)
    }
    
    func changePassword() {
        print("")
    }
}
