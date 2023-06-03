
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
        
        let checkStatus = checkStatus()
        status = checkStatus.0
        loginView.editTitle(isRegister: checkStatus.1)
    }
    
    
    
    func loginOrRegister(statusPassword: StatusLogin, password: String) {
        switch statusPassword {
        
        case .newPassword:
            
//            print("clear")
            
            if password.isEmpty {
                print("error")
                // алерт с пустым значением
            } else {
                if keychain.createPassword(password) {
                    loginView.repeatPassword()
                    print(".newPassword ------keychain.createPassword === \(password)")

                    status = .checkNewPassword
                } else {
                    // алерт знаков менее 4
                    print("// алерт знаков менее 4")
                }
            }

//            keychain.deletePassword(password: password)
            
        case .checkNewPassword:
            
//            print("clear")
            
            if keychain.repeatPassword(password) {
                keychain.checkPassword()
                print(".checkNewPassword ------keychain.repeatPassword === \(password)")
                loginView.editTitle(isRegister: true)

                keychain.addPasswordInKeychain(password)
                status = .createdPassword
                keychain.statusLogin(status: status, key: "statusLogin")

            } else {
                loginView.editTitle(isRegister: false)
                keychain.clearVariable()
                print("// вызвать алерт с ошибкой пароля")
                // вызвать алерт с ошибкой пароля
                status = .newPassword
            }
        
//            keychain.deletePassword(password: password)
                
        case .createdPassword:

            let isCheckPassword = keychain.retrievePassword(textPassword: password)

            if isCheckPassword {
                print(" isCheckPassword - if let-", isCheckPassword)
                let documentsVC = DocumentsViewController()
                navigationController?.pushViewController(documentsVC, animated: true)
                print("вошёл")
            } else {
                print("не вошел - ошибка")
            }
            
//            keychain.deletePassword(password: password)
        }
    }
    
    func checkStatus() -> (StatusLogin, Bool) {
        print("userDefaults ---", UserDefaults().integer(forKey: "statusLogin"))
        
        if let savedData = UserDefaults().data(forKey: "statusLogin") {
            do {
                let savedStatus = try JSONDecoder().decode(StatusLogin.self, from: savedData)
                print("savedStatus -", savedStatus)
                return (savedStatus, true)
            } catch let error {
                print(error, "error")
            }
        }
        return (.newPassword, false)
    }
}

extension LoginViewController: LoginViewDelegate {

    func loginOrRegister(password: String) {
        loginOrRegister(statusPassword: status, password: password)
    }
}
