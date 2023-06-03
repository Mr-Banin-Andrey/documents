
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
    
    func managerCreateName(_ url: URL) -> (URL, String) {
        let fileNameRandom = UUID().uuidString
        let name = "\(fileNameRandom).jpg"
        let imagePath = url.appending(path: name)
        
        return (imagePath, name)
    }
    
    func managerAddImage(_ image: UIImage, _ url: URL) {
        
        let data = image.jpegData(compressionQuality: 1.0)
        manager.createFile(atPath: url.path(), contents: data)
    }
    
    
    func managerFilesMore(_ url: URL) -> [DocumentsModel] {
        var images: [DocumentsModel] = []
        
        for file in contents(url) {
            if let image = UIImage(contentsOfFile: file.path()) {
                images.append(DocumentsModel(nameImage: file.lastPathComponent,
                                             image: image))
            }
        }
        images.sort {
            $0.nameImage < $1.nameImage
        }
        
        return images
    }
    
    func managerFilesLess(_ url: URL) -> [DocumentsModel] {
        var images: [DocumentsModel] = []
        
        for file in contents(url) {
            if let image = UIImage(contentsOfFile: file.path()) {
                images.append(DocumentsModel(nameImage: file.lastPathComponent,
                                             image: image))
            }
        }
        images.sort {
            $0.nameImage > $1.nameImage
        }
        
        return images
    }
    
    
    
    
    func managerDeleteImage(_ url: URL, name: String) {
        
        for file in contents(url) {
            if file.lastPathComponent == name {
                do {
                    try manager.removeItem(atPath: file.path())
                    
                } catch let error {
                    print("error", error)
                }
            }
        }
    }
    
    func contents(_ url: URL) -> [URL] {
        do {
            let contents = try manager.contentsOfDirectory(at: url,
                                                           includingPropertiesForKeys: nil,
                                                           options: [.skipsHiddenFiles])
            return contents
        } catch let error {
            print("error", error)
        }
        return [URL(fileURLWithPath: "")]
    }
}
