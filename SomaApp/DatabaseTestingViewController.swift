//
//  DatabaseTestingViewController.swift
//  SomaApp
//
//  Created by iOSdev on 10/04/2023.
//

import UIKit
import FirebaseStorage

class DatabaseTestingViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Database.Users["KKL4J8i9LlONmS1veOqXC3j6d9r1/Email"].getData { error, snapshotEmail in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            print(snapshotEmail?.value)
            if let snapshotEmail = snapshotEmail?.value as? String {
                
                self.emailLabel.text = snapshotEmail
            }
        }
        Database.Users["KKL4J8i9LlONmS1veOqXC3j6d9r1/Name"].getData { error, snapshotName in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            
            if let snapshotName = snapshotName?.value as? String {
                self.nameLabel.text = snapshotName
            }
        }
        
        let storageRef = Storage.storage().reference().child("images/tissotWatch.png")
        
        // Download the image data from storage
        storageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else if let data = data {
                // Convert the downloaded data into a UIImage
                if let image = UIImage(data: data) {
                    // Set the image as the contents of the image view
                    self?.imageView.image = image
                } else {
                    print("Error converting image data to UIImage")
                }
            } else {
                print("Error: No image data and no error message")
            }
        }
    }
}
     
           

       
//        Database.Users["KKL4J8i9LlONmS1veOqXC3j6d9r1/Photo"].getData { error, snapshotPhoto in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return;
//            }
//
//            if let snapshotPhoto = snapshotPhoto?.value as? String {
//                self.imageView.image = snapshotPhoto
//            }
//        }
        // Load the image from Firebase Storage and set it as the image property of the UIImageView
      
       //     self.imageView.image = image
       // }
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
        
    

