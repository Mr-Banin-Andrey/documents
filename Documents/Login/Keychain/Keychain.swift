
import Foundation
import Security


class Keychain {
    
    private var firstPassword = ""
    private var secondPassword = ""
    
    let userDefaults = UserDefaults.standard

    
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
        ] as [CFString : Any] as CFDictionary
        
        let status = SecItemAdd(attributes, nil)
        guard status == errSecDuplicateItem || status == errSecSuccess else {
            print("Error, \(status)")
            return
        }
        
        print("пароль добавлен")
    }
    
    func retrievePassword(textPassword: String) -> Bool {
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(query, &extractedData)
        
        guard status == errSecItemNotFound || status == errSecSuccess else {
            print("Error, \(status)")
            return false
        }
        
        guard status != errSecItemNotFound else {
            print("Password not found in Keychain")
            return false
        }
        
        guard let passData = extractedData as? Data,
              let password = String(data: passData, encoding: .utf8) else {
            print("невозможно преобразовать data в пароль")
            return false
        }
        
        guard password == textPassword else {
            
            print("password -", password)
            print("textPassword -", textPassword)
            print("пароль неверный")
            return false
        }
            
        return true
    }
    
    func statusLogin(status: StatusLogin, key: String) {
        do {
            let data = try JSONEncoder().encode(status)
            userDefaults.set(data, forKey: key)
            print("закодирован статус")
        } catch let error {
            print(error)
        }
        
    }
    
    func changePassword(password: String) {
        
        guard let passData = password.data(using: .utf8) else {
            print("Error - not could Data from password")
            return
        }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
//            kSecValueData: passData,
        ] as [CFString : Any] as CFDictionary
        
        let attributesToUpdate = [
            kSecValueData: passData,
        ] as [CFString : Any] as CFDictionary
        
        
        let status = SecItemUpdate(query, attributesToUpdate)
        guard status == errSecSuccess else {
            print("Невозможно обновить пароль, ошибка: \(status)")
            return
        }
        
        print("пароль обновлен")
        
    }
    
    func deletePassword(password: String) {
        
        guard let passData = password.data(using: .utf8) else {
            print("Error - not could Data from password")
            return
        }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passData,
        ] as [CFString : Any] as CFDictionary
        
        let status = SecItemDelete(query)
        guard status == errSecItemNotFound || status == errSecSuccess else {
            print("Error, \(status)")
            return
        }
        
        guard status != errSecItemNotFound else {
            print("Password not found in Keychain")
            return
        }
        
        print("password deleted")
    }
    
}
