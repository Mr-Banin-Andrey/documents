
import Foundation
import UIKit




class LoginViewController: UIViewController {
    
    private lazy var loginView = LoginView(delegate: self)
    
    private lazy var keychain = Keychain()
    
    private lazy var isCreatePassword: Bool = false
    
    private lazy var status: StatusLogin = .newPassword
    
    override func loadView() {
        super.loadView()
        
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.status(isRegister: false)
        
    }
    
    func loginOrRegister(statusPassword: StatusLogin, password: String) {
        switch statusPassword {
        case .newPassword:
            
            if password.isEmpty {
                print("error")
                // алерт с пустым значением
            } else {
                if keychain.createPassword(password) {
                    loginView.createPassword()
                    print(".newPassword ------keychain.createPassword === \(password)")
                    
                    status = .checkNewPassword
                } else {
                    // алерт знаков менее 4
                    print("// алерт знаков менее 4")
                }
                
            }
            
            
        
        case .checkNewPassword:
            
            if keychain.repeatPassword(password) {
                keychain.checkPassword()
                print(".checkNewPassword ------keychain.repeatPassword === \(password)")
                loginView.status(isRegister: true)
                
                status = .createdPassword
            } else {
                loginView.status(isRegister: false)
                keychain.clearVariable()
                print("// вызвать алерт с ошибкой пароля")
                // вызвать алерт с ошибкой пароля
                status = .newPassword
            }
        
        case .createdPassword:
            print("вошёл")
            
        }
    }
}

extension LoginViewController: LoginViewDelegate {

    func loginOrRegister(password: String) {
        loginOrRegister(statusPassword: status, password: password)
    }
}
