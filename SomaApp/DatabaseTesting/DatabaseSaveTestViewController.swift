import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class DatabaseSaveTestViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func selectImageTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveDataTapped(_ sender: Any) {
        guard let name = nameTextField.text, let email = emailTextField.text, let image = imageView.image else {
            print("Error: Some fields are empty")
            return
        }

        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")

        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            print("Error: Failed to get image data")
            return
        }

        let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                var data = ["name": name, "email": email, "imageUrl": downloadURL.absoluteString]
                // Create a database reference
                let databaseRef = Database.Users.users.childByAutoId()

                // Create a child reference for "users" node
                let usersRef = databaseRef.child("users")

                // Create a new child node with an automatically generated ID
                let newChildRef = usersRef.childByAutoId()

                // Set the values to be saved in the database
                 data = ["name": name, "email": email]

                // Save the data to the new child node
                newChildRef.setValue(data) { (error, ref) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else {
                        print("Data saved successfully!")
                    }
                }

                databaseRef.setValue(data) { (error, ref) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else {
                        print("Data saved successfully")
                    }
                }
            }
        }

    }
}
