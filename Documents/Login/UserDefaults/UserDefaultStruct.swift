
import Foundation

struct UserDefaultStruct {
    
    func statusEncoder(status: StatusLogin, key: String) {
        do {
            let data = try JSONEncoder().encode(status)
            UserDefaults.standard.set(data, forKey: key)
            print("закодирован статус")
        } catch let error {
            print(error)
        }
        
    }
    
    
    func statusDecoder() -> StatusLogin {
        
        if let savedData = UserDefaults().data(forKey: "statusLogin") {
            do {
                let savedStatus = try JSONDecoder().decode(StatusLogin.self, from: savedData)
                print("раскодирован статус -", savedStatus)
                return savedStatus
            } catch let error {
                print(error, "error")
            }
        }
        return .newPassword
    }
}

