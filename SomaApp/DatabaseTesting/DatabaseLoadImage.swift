//import UIKit
import FirebaseStorage
import UIKit

class ImportImage {
    static let shared = ImportImage ()
    
    func downloadImage(imageUuid: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let storageRef = Storage.storage().reference().child("images/\(imageUuid)")
        
        // Download the image data from storage
        storageRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil, error)
            } else if let data = data {
                // Convert the downloaded data into a UIImage
                if let image = UIImage(data: data) {
                    completion(image, nil)
                } else {
                    print("Error converting image data to UIImage")
                    completion(nil, NSError(domain: "FirebaseImageDownloader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error converting image data to UIImage"]))
                }
            } else {
                print("Error: No image data and no error message")
                completion(nil, NSError(domain: "FirebaseImageDownloader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error: No image data and no error message"]))
            }
        }
    }
}
