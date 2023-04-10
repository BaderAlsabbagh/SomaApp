import UIKit

import FirebaseDatabase
import FirebaseStorage

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
    
    class Storage {
        static let ref = FirebaseStorage.Storage.storage(url: "gs://refur-2a2f0.appspot.com/").reference()
        
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
        
        static func loadImage(uuid: String) -> UIImage? {
            
            var image: UIImage? = nil
            
            ref.child("images/\(uuid).png").getData(maxSize:(104857666), completion: { (data, error) in
                
                guard error == nil else {
                    print("Failed to download", error ?? "")
                    return
                }
                
                if let image = data {
                    let image = UIImage(data: image)
                }
            })
            
            return image
        }
    }
    
    
    private init() { }
    
}
