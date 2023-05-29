
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
    
    
    func managerFiles(_ url: URL) -> [UIImage] {
        
        do {
            let contents = try manager.contentsOfDirectory(at: url,
                                                           includingPropertiesForKeys: nil,
                                                           options: [.skipsHiddenFiles])
            print(contents.count)
            var images: [UIImage] = []
            for file in contents {
                if let image = UIImage(contentsOfFile: file.path()) {
                    images.append(image)
                }
            }
            return images
        } catch let error {
            print(error, "error")
        }
        return [UIImage()]
    }
    
    
    func managerDeleteImage(_ url: URL, numberImage: Int) {
        do {
            let contents = try manager.contentsOfDirectory(at: url,
                                                           includingPropertiesForKeys: nil,
                                                           options: [.skipsHiddenFiles])
            
            let abs = contents[numberImage]
            try manager.removeItem(atPath: abs.path())
        } catch let error {
            print("error", error)
        }
    }
    
    
}
