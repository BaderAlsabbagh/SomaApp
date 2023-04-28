import UIKit

import FirebaseDatabase
import FirebaseStorage
import Kingfisher

// exmpale for setting database entieres
// Database.Users.users["exmaple-uuid"].setValue(["name": "value"])
//Database.Users.users["exmaple-uuid"].getValue(


class Database {
    
    
    class Users {
        static let ref = FirebaseDatabase.Database.database(url: "https://somaapp-a3768-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        static var users = ref.child("users")
        
        //static var currentUser: DatabaseReference { ref.child(User.user.uid!) }
        
        static subscript (uuid: String) -> DatabaseReference {
            return Database.Users.users.child(uuid)
        }
    }
    
    class Products {
        static let ref = FirebaseDatabase.Database.database(url: "https://somaapp-a3768-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        static var products = ref.child("products")
        
        //static var currentUser: DatabaseReference { ref.child(User.user.uid!) }
        
        static subscript (uuid: String) -> DatabaseReference {
            return Database.Products.products.child(uuid)
        }
    }
    
    class Storage {
        static let ref = FirebaseStorage.Storage.storage(url: "gs://somaapp-a3768.appspot.com").reference()
        
        static func saveImage(image: UIImage) -> String? {
            
            guard let imageData = image.pngData() else { return nil }
            
            var imageUuid: String? = UUID().uuidString
            
            ref.child("images/\(imageUuid!).png").putData(imageData, metadata: nil, completion: { _, error in
                
                guard error == nil else {
                    print("Failed to upload", error ?? "")
                    
                    imageUuid = nil
                    return
                }
            })
            
            return imageUuid
        }
        
        static func loadImage(view: UIImageView, uuid: String) {
                    
                    ref.child("images/\(uuid)").downloadURL { url, error in
                        
                        guard error == nil else {
                            print("Failed to download", error ?? "")
                            return
                        }
                        
                        guard let url = url else { return }
                        view.kf.setImage(with: url)
                    }
                }
    }
    
    
    private init() { }
    
}
