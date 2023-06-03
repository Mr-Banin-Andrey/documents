

import Foundation
import UIKit
import SnapKit

class DocumentsViewController: UIViewController {
        
    private lazy var documentsView = DocumentsView(delegate: self)
    
    private let manager = DocumentsFileManager()
    
    var images: [DocumentsModel] = []
    
    var isMySwitcher: Bool = true
            
    override func loadView() {
        super.loadView()
        view = documentsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
        navigationItem.hidesBackButton = true
        
//        moreOrLess(mySwitcher: SettingsViewController().sorted())
//        self.images = manager.managerFilesMore(manager.managerCreateUrl())
        moreOrLess(mySwitcher: isMySwitcher)
        
        self.documentsView.configureTableView(dataSource: self,
                                              delegate: self)
        
        self.documentsView.navigationController(navigation: navigationItem,
                                                rightButton: documentsView.rightButton,
                                                title: "Documents")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//
//        moreOrLess(mySwitcher: isMySwitcher)
//        print("SettingsViewController().sorted(UISwitch())", SettingsViewController().sorted(UISwitch()))
//
//    }
    
    func moreOrLess(mySwitcher: Bool) {
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(receivedNotification(notification:)),
//                                               name: NSNotification.Name.,
//                                               object: nil)
        
        print("moreOrLess", mySwitcher)
        if mySwitcher {
//            print("SettingsViewController().mySwitch", SettingsViewController().mySwitch)
            self.images = manager.managerFilesMore(manager.managerCreateUrl())
//            print(images)
            documentsView.reload()
            NotificationCenter.default.addObserver(forName: NSNotification.Name("default"), object: nil, queue: nil) { (notification) in
                print("notification")
            }
            

        } else {
            
//            print("SettingsViewController().mySwitch", SettingsViewController().mySwitch)
            self.images = manager.managerFilesLess(manager.managerCreateUrl())
//            print(images)
            documentsView.reload()
        }
    }
    
//    @objc func receivedNotification(notification: Notification) {
//
//        //Take Action on Notification
//
//    }
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
        
        cell.imageView?.image = images[indexPath.row].image
        cell.textLabel?.text = images[indexPath.row].nameImage
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            
            let nameImage = self.images[indexPath.row].nameImage

            self.manager.managerDeleteImage(
                self.manager.managerCreateUrl(),
                name: nameImage)

            self.images.remove(at: indexPath.row)
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
        
        let createNameFile = manager.managerCreateName(manager.managerCreateUrl())
        let url = createNameFile.0
        let name = createNameFile.1
        
        images.append(DocumentsModel(nameImage: name, image: image))
        
        manager.managerAddImage(image, url)
        documentsView.reload()
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
        
}
