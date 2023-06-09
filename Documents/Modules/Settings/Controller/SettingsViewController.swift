
import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var delegateView = SettingsView(delegate: self)
    

    override func loadView() {
        super.loadView()
        
        view = delegateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension SettingsViewController: SettingsViewDelegate {
    func sorted(_ sender: UISwitch) {

        if sender.isOn {
            delegateView.changeNameSwitchLabel(isSwitch: sender.isOn)
            print("on")
            NotificationCenter.default.post(name: NSNotification.Name("senderOn"),
                                            object: self)

        } else {
            delegateView.changeNameSwitchLabel(isSwitch: sender.isOn)
            print("off")
            NotificationCenter.default.post(name: NSNotification.Name("senderOff"),
                                            object: self)
        }
    }
    
    func changePassword() {
        
        let loginVc = LoginViewController()
        let navСontroller = UINavigationController(rootViewController: loginVc)
        self.navigationController?.present(navСontroller, animated: true, completion: nil)
    }
}
