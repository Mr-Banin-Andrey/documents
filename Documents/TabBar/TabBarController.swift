
import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    var loginViewController: UIViewController!
    var settingsViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBar()
    }
    
    private func setupTabBar() {
        
        loginViewController = UINavigationController(rootViewController: LoginViewController())
        settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        
        self.viewControllers = [loginViewController, settingsViewController]
        
        let login = UITabBarItem(title: "Documents", image: UIImage(systemName: "newspaper"), tag: 0)
        let settings = UITabBarItem(title: "Settings", image: UIImage(systemName: "person"), tag: 1)
        
        loginViewController.tabBarItem = login
        settingsViewController.tabBarItem = settings
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.9154649377, green: 0.9269897342, blue: 0.9267870188, alpha: 1)
        
    }
    
}
