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
        
        let imageUuid = "tissotWatch"
                ImportImage.shared.downloadImage(imageUuid: imageUuid) { [weak self] (image, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else if let image = image {
                        self?.imageView.image = image
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
        
        
    

