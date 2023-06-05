
import Foundation
import UIKit


class LoginViewController: UIViewController {
    
    private lazy var loginView = LoginView(delegate: self)
    
    private lazy var keychain = Keychain()
        
    private lazy var status: StatusLogin = .newPassword
    
    override func loadView() {
        super.loadView()
        
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusDecoder = UserDefaultStruct().statusDecoder()
        tabBarController?.tabBar.isHidden = true
        status = statusDecoder

        
        if isModal {
            self.editTitle()
        } else {
            loginView.editTitle(status: statusDecoder)
        }
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
            status = .checkNewPassword
            loginView.editTitle(status: status)
      
        case .checkNewPassword:

            if keychain.repeatPassword(password) {
                status = .createdPassword
                loginView.editTitle(status: status)
                UserDefaultStruct().statusEncoder(status: status, key: "statusLogin")
                pushViewController()
            } else {
                loginView.showAlert(vc: self,
                                    title: "Ошибка",
                                    message: "Пароли не совпадают",
                                    button: "Попробовать ещё раз")
                status = .newPassword
                loginView.editTitle(status: status)
            }

        case .createdPassword:

            let isCheckPassword = keychain.retrievePassword(textPassword: password)

            if isCheckPassword {
                pushViewController()
            } else {
                loginView.showAlert(vc: self, title: "Ошибка", message: "Неверный пароль", button: "Попробовать ещё раз")
            }
        }
    }
    
    private func pushViewController() {
        let documentsVC = DocumentsViewController()
        navigationController?.pushViewController(documentsVC, animated: true)
    }
    
    private func changePassword(password: String) {
        keychain.changePassword(password: password)
    }
    
    private func editTitle() {
        loginView.loginOrRegisterButton.setTitle("Изменить пароль", for: .normal)
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
