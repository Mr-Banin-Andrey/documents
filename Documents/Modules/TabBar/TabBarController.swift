
import Foundation
import UIKit

class TabBarController {
    
    
    func setupTabBar() {
        
        let tabBarCont = UITabBarController.init()
        let navigationController = UINavigationController()
        
        let documentsVc = LoginViewController()
        let documentsNavigation = UINavigationController(rootViewController: DocumentsViewController())
        
        let settingsVc = SettingsViewController()
        let settingsNavigation = UINavigationController(rootViewController: SettingsViewController())
        
        let documents = UITabBarItem(title: "Documents", image: UIImage(systemName: "newspaper"), tag: 0)
        let settings = UITabBarItem(title: "Settings", image: UIImage(systemName: "person"), tag: 1)
        
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.9154649377, green: 0.9269897342, blue: 0.9267870188, alpha: 1)
        
        documentsVc.tabBarItem = documents
        settingsVc.tabBarItem = settings

        
        tabBarCont.viewControllers = [documentsNavigation, settingsNavigation]
        navigationController.pushViewController(tabBarCont, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        
    }
    
}
