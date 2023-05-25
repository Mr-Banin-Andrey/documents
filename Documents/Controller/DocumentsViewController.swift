

import Foundation
import UIKit
import SnapKit

class DocumentsViewController: UIViewController {
        
    private lazy var documentsView = DocumentsView(delegate: self)
        
    var images: [UIImage] = []
        
    override func loadView() {
        super.loadView()
        view = documentsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arrive()
        
        documentsView.configureTableView(dataSource: self, delegate: self)
        documentsView.navigationController(navigation: navigationItem, rightButton: documentsView.rightButton, title: "Documents")
        
        documentsView.reload()
    }
    
    func arrive() {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: DocumentsFileManager().managerCreateUrl(),
                                                           includingPropertiesForKeys: nil,
                                                               options: [.skipsHiddenFiles])
                print(contents.count)
                for file in contents {
                    let filePath = file.lastPathComponent
                    print(filePath)
                    let abs = filePath
                    images.append(UIImage(named: abs)!)
                }
            } catch let error {
                print(error, "error")
            }
        }
}


extension DocumentsViewController: DocumentsViewDelegate {
    func addImage() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension DocumentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCellId", for: indexPath)
        
        cell.imageView?.image = images[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UIScreen.main.bounds.size.height / 4
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            
//            DocumentsFileManager().managerDeleteImage()
            self.images.removeAll()
            self.documentsView.reload()
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  else { return }
        
        images.append(image)
        let manager = DocumentsFileManager()
        manager.managerAddImage(image, manager.managerCreateName(manager.managerCreateUrl()))
        documentsView.reload()
        
        
        print("images",images)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
        
}
