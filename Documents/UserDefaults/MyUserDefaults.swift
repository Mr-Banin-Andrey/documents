

import Foundation

//struct MyUserDefaults {
//    
//    let userDefaults = UserDefaults.standard
//    
//    
//    func statusLogin(status: StatusLogin, key: String) {
//        do {
//            let data = try JSONEncoder().encode(status)
//            userDefaults.set(data, forKey: key)
//            print("закодирован статус")
//        } catch let error {
//            print(error)
//        }
//        
//    }
//    
//    if let savedData = UserDefaults().data(forKey: "statusLogin") {
//        do {
//            let savedStatus = try JSONDecoder().decode(StatusLogin.self, from: savedData)
//            print("savedStatus -", savedStatus)
//            return (savedStatus, true)
//        } catch let error {
//            print(error, "error")
//        }
//    }
//}
