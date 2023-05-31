
import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    private lazy var loginView = LoginView(delegate: self)
    
    override func loadView() {
        super.loadView()
        
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.status(isRegister: false)
    }
}

extension LoginViewController: LoginViewDelegate {
    func loginOrRegister() {
        print("pushka")
    }
}
