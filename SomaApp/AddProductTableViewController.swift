//
//  AddProductTableViewController.swift
//  SomaApp
//
//  Created by iOSdev on 02/04/2023.
//
import UIKit
import Firebase
import FirebaseStorage

class AddProductTableViewController: UITableViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    
    // Product Listing Outlets (TEXT FIELDS)
    
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var startingPriceTextField: UITextField!
    @IBOutlet weak var minimumIncrementTextField: UITextField!
    @IBOutlet weak var buyItNowTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var submitItem: UIButton!
    
    let categories = ["Clothing", "Bags", "Footwear", "Eyewear", "Accessories", "Jewelry", "Watches", "Other"]
    let genders = ["Male", "Female", "Both"]
    let times = ["1 Hour", "3 Hours", "6 Hours", "12 Hours", "1 Day", "3 Days", "7 Days"]
    let conditions = ["New", "Open Box", "Barely Used", "Used"]
    
    var categoryPickerView = UIPickerView()
    var genderPickerView = UIPickerView()
    var timePickerView = UIPickerView()
    var conditionPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignPickerViews()
        
        submitItem.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
   
        let currentOffset = tableView.contentOffset
        
        if currentOffset.y > 0 {
               tableView.setContentOffset(CGPoint.zero, animated: false)
           }

        productNameTextField.text = ""
        descriptionTextField.text = ""
        startingPriceTextField.text = ""
        minimumIncrementTextField.text = ""
        buyItNowTextField.text = ""
        categoryTextField.text = ""
        genderTextField.text = ""
        timeTextField.text = ""
        conditionTextField.text = ""
        brandTextField.text = ""
        imageView.image = nil
        checkMark.isSelected = false
        submitItem.isEnabled = false
    }
    
    //Image Selection Code
    @IBAction func uploadImagesButtonTapped(_ sender: UIButton) {
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
    
    @IBAction func checkMarkButtonPressed(_ sender: Any) {
        
        guard
            let categoryTextField = categoryTextField.text, !categoryTextField.isEmpty
        else {
            let alert = UIAlertController(
                title: "Invalid Request",
                message: "Please fill empty fields",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            self.present(alert, animated: true)
            return
        }
        
        validated.toggle()
    }
    
    var validated = false {
        didSet {
            checkMark.isSelected = validated
            submitItem.isEnabled = validated
        }
    }
    
    @IBAction func submitItemButtonPressed(_ sender: Any) {
        let alert = UIAlertController(
            title: "Submit Listing",
            message: "Are you sure you want to submit the listing?",
            preferredStyle: .alert
        )
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.uploadImageToStorage { [weak self] metadata in
                guard let self = self else { return }
                
                self.saveDataToDatabase(imageUuid: metadata.name ?? "")
                self.performSegue(withIdentifier: "unwindToHome", sender: self)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    private func uploadImageToStorage(completion: @escaping (StorageMetadata) -> Void) {
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.75) else {
            print("Error: Failed to get image data")
            return
        }
        
        let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let metadata = metadata else {
                print("Error: Failed to get metadata")
                return
            }
            
            completion(metadata)
        }
    }

    private func saveDataToDatabase(imageUuid: String) {
        guard let productName = productNameTextField.text, !productName.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty,
              let startingPrice = startingPriceTextField.text, !startingPrice.isEmpty,
              let minimumIncrement = minimumIncrementTextField.text, !minimumIncrement.isEmpty,
              let timePeriod = timeTextField.text, !timePeriod.isEmpty,
              let category = categoryTextField.text,
              let gender = genderTextField.text, !gender.isEmpty,
              let condition = conditionTextField.text, !condition.isEmpty
        else {
            print("Error: Required fields are empty")
            return
        }
        
        let data = [
            "productName": productName,
            "description": description,
            "startingPrice": startingPrice,
            "minimumIncrement": minimumIncrement,
            "buyItNow": buyItNowTextField.text ?? "",
            "timePeriod": timePeriod,
            "category": category,
            "gender": gender,
            "brand": brandTextField.text ?? "",
            "condition": condition,
            "imageUuid": imageUuid
        ]
        
        let databaseRef = Database.Products.products.childByAutoId()
        databaseRef.setValue(data) { (error, ref) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Data saved successfully!")
            }
        }
    }

    func checkIfUserIsLoggedIn() -> Bool {
       if Auth.auth().currentUser != nil {
          // User is logged in
          return true
       } else {
          // User is not logged in
          return false
       }
    }
        
        
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch pickerView.tag {
            case 1:
                return categories.count
            case 2:
                return genders.count
            case 3:
                return times.count
            case 4:
                return conditions.count
            default:
                return 1
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch pickerView.tag {
            case 1:
                return categories[row]
            case 2:
                return genders[row]
            case 3:
                return times[row]
            case 4:
                return conditions[row]
            default:
                return "Picker data not found."
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch pickerView.tag {
            case 1:
                categoryTextField.text = categories[row]
                categoryTextField.resignFirstResponder()
            case 2:
                genderTextField.text = genders[row]
                genderTextField.resignFirstResponder()
            case 3:
                timeTextField.text = times[row]
                timeTextField.resignFirstResponder()
            case 4:
                conditionTextField.text = conditions[row]
                conditionTextField.resignFirstResponder()
            default:
                return
            }
        }
        
        func assignPickerViews(){
            categoryTextField.inputView = categoryPickerView
            genderTextField.inputView = genderPickerView
            timeTextField.inputView = timePickerView
            conditionTextField.inputView = conditionPickerView
            
            //        categoryTextField.placeholder = "Select Category"
            //        genderTextField.placeholder = "Select Gender"
            //        timeTextField.placeholder = "Select Time Period"
            
            categoryTextField.textAlignment = .left
            genderTextField.textAlignment = .left
            timeTextField.textAlignment = .left
            categoryPickerView.delegate = self
            categoryPickerView.dataSource = self
            genderPickerView.delegate = self
            genderPickerView.dataSource = self
            timePickerView.delegate = self
            timePickerView.dataSource = self
            conditionPickerView.delegate = self
            conditionPickerView.dataSource = self
            categoryPickerView.tag = 1
            genderPickerView.tag = 2
            timePickerView.tag = 3
            conditionPickerView.tag = 4
        }
}

        
 
