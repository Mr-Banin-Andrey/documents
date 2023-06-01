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
//        let status = SecItemAdd([], nil)
//
//        guard status == errSecDuplicateItem || status == errSecSuccess else {
//            print("Error, \(status)")
//            return
//        }
    }
}
