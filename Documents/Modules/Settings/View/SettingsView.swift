
import Foundation
import UIKit
import SnapKit

protocol SettingsViewDelegate: AnyObject {
    func sorted(_ sender: UISwitch)
    func changePassword()
}

class SettingsView: UIView {
    
    private weak var delegate: SettingsViewDelegate?
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Изменить пароль", for: .normal)
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        return button
    }()
    
    private var sortSwitch: UISwitch = {
        let sortSwitch = UISwitch()
        sortSwitch.translatesAutoresizingMaskIntoConstraints = false
        sortSwitch.addTarget(self, action: #selector(sortPhoto), for: .valueChanged)
        sortSwitch.isOn = true
        return sortSwitch
    }()
    
    private lazy var nameSwitch: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сортировка от А-Я"
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    init(delegate: SettingsViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.setupUi()
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUi() {
        self.addSubview(self.changePasswordButton)
        self.addSubview(self.sortSwitch)
        self.addSubview(self.nameSwitch)
        
        self.changePasswordButton.snp.makeConstraints { maker in
            maker.centerY.equalTo(self.snp.centerY)
            maker.leading.equalTo(self.snp.leading).inset(32)
        }
        
        self.sortSwitch.snp.makeConstraints { maker in
            maker.centerY.equalTo(self.snp.centerY)
            maker.trailing.equalTo(self.snp.trailing).inset(64)
        }
        
        self.nameSwitch.snp.makeConstraints { maker in
            maker.top.equalTo(self.sortSwitch.snp.bottom).offset(8)
            maker.centerX.equalTo(self.sortSwitch.snp.centerX)
            
        }
    }
    
    func changeNameSwitchLabel(isSwitch: Bool) {
        if isSwitch {
            self.nameSwitch.text = "Сортировка от А-Я"
        } else {
            self.nameSwitch.text = "Сортировка от Я-А"
        }
    }
    
    @objc private func changePassword() {
        delegate?.changePassword()
    }
    
    @objc private func sortPhoto(_ sender: UISwitch) {
        delegate?.sorted(sortSwitch)
    }
    
    
}

