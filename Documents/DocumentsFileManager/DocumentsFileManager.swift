
import Foundation
import UIKit

struct DocumentsFileManager {
    
    private let manager = FileManager.default
    
    func managerCreateUrl() -> URL {
        do {
            let documentsUrl = try manager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            return documentsUrl
        } catch let error {
            print(error, "error")
        }
        return URL(filePath: "")
    }
    
    func managerCreateName(_ url: URL) -> URL {

        let fileNameRandom = UUID().uuidString
        let imagePath = url.appending(path: "\(fileNameRandom).jpg")
        
        return imagePath
    }
    
    func managerAddImage(_ image: UIImage, _ url: URL) {
        
        let data = image.jpegData(compressionQuality: 1.0)
        manager.createFile(atPath: url.path(), contents: data)
    }
    
    
    func managerFiles(_ url: URL) {
        do {
            let contents = try manager.contentsOfDirectory(at: url,
                                                       includingPropertiesForKeys: nil ,
                                                           options: [.skipsHiddenFiles])
            print(contents.count)
            for file in contents {
                let filePath = file.lastPathComponent
                print(filePath)
                DocumentsViewController().images.append(UIImage(named: filePath) ?? UIImage())
            }
        } catch let error {
            print(error, "error")
        }
        print(DocumentsViewController().images)
    }
    
    
//    func managerDeleteImage() {
//        do {
////            print(documentsUrl())
//            try manager.removeItem(at: documentsUrl())
//
////            try manager.removeItem(atPath: <#T##String#>)
////            try manager.removeItem(at: <#T##URL#>)
//        } catch let error {
//            print("error", error)
//        }
//    }
    
    
}
