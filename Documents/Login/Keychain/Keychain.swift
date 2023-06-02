//
//  Keychain.swift
//  Documents
//
//  Created by Андрей Банин on 1.6.23..
//

import Foundation
import Security


//protocol KeychainDelegate: AnyObject {
//    func addPassword()
//    func checkPassword()
//}

class Keychain {
    
//    private weak var delegate: KeychainDelegate?
    
    private var firstPassword = ""
    private var secondPassword = ""
    
    let userDefaults = UserDefaults.standard
//    init(delegate: KeychainDelegate) {
//        self.delegate = delegate
//    }
    
    
    func createPassword(_ password: String) -> Bool {
        if password.count >= 4 {
            firstPassword = password
            return true
        }
        return false
    }
    
    func repeatPassword(_ password: String) -> Bool {
        if firstPassword == password {
            secondPassword = password
            return true
        }
        return false
    }
    
    func checkPassword() {
        
        print("firstPassword -", firstPassword)
        print("secondPassword -", secondPassword)
    }
    
    func clearVariable() {
        firstPassword = ""
        secondPassword = ""
    }
    
    
    
    func addPasswordInKeychain(_ password: String) {
       
        guard let passData = password.data(using: .utf8) else {
            print("Error - not could Data from password")
            return
        }
        
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passData,
//            kSecAttrServer: password.service
        ] as CFDictionary
        
        let status = SecItemAdd(attributes, nil)
        guard status == errSecDuplicateItem || status == errSecSuccess else {
            print("Error, \(status)")
            return
        }
        
        print("New password added ")
    }
    
    func retrievePassword() -> String? {
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
//            kSecValueData: passData,
//            kSecAttrServer: password.service
        ] as CFDictionary
        
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(query, &extractedData)
        
        guard status == errSecItemNotFound || status == errSecSuccess else {
            print("Error, \(status)")
            return nil
        }
        
        guard status != errSecItemNotFound else {
            print("Password not found in Keychain")
            return nil
        }
        
        guard let passData = extractedData as? Data,
              let password = String(data: passData, encoding: .utf8) else {
            print("невозможно преобразовать data в пароль")
            return nil
        }
        
        return password
    }
    
    func statusLogin(status: StatusLogin, key: String) {
        do {
            let data = try JSONEncoder().encode(status)
            userDefaults.set(data, forKey: key)
        } catch let error {
            print(error)
        }
        
    }
    
    
}
