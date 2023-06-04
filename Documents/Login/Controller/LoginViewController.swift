
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
        
        tabBarController?.tabBar.isHidden = true
        
        let checkStatus = checkStatus()
        status = checkStatus.0
        loginView.editTitle(isRegister: checkStatus.1)
    }    
    
    func loginOrRegister(statusPassword: StatusLogin, password: String) {
        switch statusPassword {
        
        case .newPassword:
            
//            keychain.deletePassword(password: password)
            guard password.isEmpty == false else {
                return loginView.showAlert(vc: self,
                                           title: "Ошибка",
                                           message: "Пароль должен быть заполнен",
                                           button: "Попробовать ещё раз")}

            guard keychain.createPassword(password) == true else {
                return loginView.showAlert(vc: self,
                                           title: "Ошибка",
                                           message: "Пароль не менее 4 символов",
                                           button: "Попробовать ещё раз")}
            

            loginView.repeatPassword()
            status = .checkNewPassword

        case .checkNewPassword:

            if keychain.repeatPassword(password) {
                
                keychain.checkPassword()
                loginView.editTitle(isRegister: true)

                keychain.addPasswordInKeychain(password)
                status = .createdPassword
                keychain.statusLogin(status: status, key: "statusLogin")

            } else {
                loginView.editTitle(isRegister: false)
                keychain.clearVariable()
                loginView.showAlert(vc: self,
                                    title: "Ошибка",
                                    message: "Пароль не менее 4 символов",
                                    button: "Попробовать ещё раз")
                status = .newPassword
            }

        case .createdPassword:

            let isCheckPassword = keychain.retrievePassword(textPassword: password)

            if isCheckPassword {
                let documentsVC = DocumentsViewController()
                navigationController?.pushViewController(documentsVC, animated: true)
            } else {
                loginView.showAlert(vc: self, title: "Ошибка", message: "Неверный пароль", button: "Попробовать ещё раз")
            }
//            changePassword(password: password)
//            keychain.deletePassword(password: password)
        }
    }
    
    func changePassword(password: String) {
        keychain.changePassword(password: password)
    }
    
    func checkStatus() -> (StatusLogin, Bool) {
        
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
        
        if isModal {
            guard password.isEmpty == false else {
                return loginView.showAlert(vc: self,
                                           title: "Ошибка",
                                           message: "Пароль должен быть заполнен",
                                           button: "Попробовать ещё раз")}
            guard keychain.createPassword(password) == true else {
                return loginView.showAlert(vc: self,
                                           title: "Ошибка",
                                           message: "Пароль не менее 4 символов",
                                           button: "Попробовать ещё раз")}
            changePassword(password: password)
            self.dismiss(animated: true)
            
        } else {
            loginOrRegister(statusPassword: status, password: password)
        
        }
        let login = LoginViewController()
        login.dismiss(animated: true)
    }
}

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
