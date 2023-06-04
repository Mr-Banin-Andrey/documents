
import Foundation
import UIKit
import SnapKit

protocol LoginViewDelegate: AnyObject {
    func loginOrRegister(password: String)
}

class LoginView: UIView {
    
    private weak var delegate: LoginViewDelegate?
    
    private lazy var loginOrRegisterButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .darkGray
        label.addTarget(self, action: #selector(loginOrRegister), for: .touchUpInside)
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.isSecureTextEntry = true
        return textField
    }()
    
    init(delegate: LoginViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(self.loginOrRegisterButton)
        self.addSubview(self.passwordTextField)

        self.loginOrRegisterButton.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.snp.centerX)
            maker.centerY.equalTo(self.snp.centerY) 
            maker.height.equalTo(32)
            maker.width.equalTo(200)
        }

        self.passwordTextField.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.snp.centerX)
            maker.top.equalTo(self.snp.top).inset(350)
            maker.height.equalTo(32)
            maker.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    func editTitle(isRegister: Bool) {
        
        if isRegister {
            passwordTextField.placeholder = "....."
            loginOrRegisterButton.setTitle("Введите пароль", for: .normal)
        } else {
            passwordTextField.placeholder = " Пароль минимум из 4 символов "
            loginOrRegisterButton.setTitle("Создать пароль", for: .normal)
        }
    }
    
    func repeatPassword() {
        loginOrRegisterButton.setTitle("Повторите пароль", for: .normal)
    }
    
    func showAlert(vc: UIViewController, title: String, message: String, button: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: button, style: .default)
        alert.addAction(action)
        
        vc.present(alert, animated: true)
    }
    
    @objc private func loginOrRegister() {
        guard let password = passwordTextField.text else { return }
        delegate?.loginOrRegister(password: password)
        passwordTextField.text = ""
    }
}
