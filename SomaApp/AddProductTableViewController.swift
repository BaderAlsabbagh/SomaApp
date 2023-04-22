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
        return 1
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
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
    
    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var submitItem: UIButton!
    
    var imageView: UIImageView?
    // Array of image views to display in the scroll view
    var imageViews = [UIImageView]()
    var imageUuid: String?
    
    let categories = ["Clothing", "Bags", "Footwear", "Eyewear", "Accessories", "Jewelry", "Other"]
    let genders = ["Male", "Female", "Both"]
    let times = ["1 Hour", "3 Hours", "6 Hours", "12 Hours", "1 Day", "3 Days", "7 Days"]
    let conditions = ["New", "Open Box", "Barely Used", "Used"]
    
    var categoryPickerView = UIPickerView()
    var genderPickerView = UIPickerView()
    var timePickerView = UIPickerView()
    var conditionPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegate of the scroll view to self
        scrollView.delegate = self
        // Set the content size of the scroll view based on the number of image views
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageViews.count), height: scrollView.frame.height)
        // Set the number of pages on the page control
        pageControl.numberOfPages = imageViews.count
        
        assignPickerViews()
        
        submitItem.isEnabled = false
        
    }
    
    //Image Selection Code
    @IBAction func uploadImagesButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "",
            message: "Are you sure you want upload images?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            
            let viewController = UIImagePickerController()
            viewController.sourceType = .photoLibrary
            viewController.delegate = self
            viewController.allowsEditing = true
            self.present(viewController, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
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
    
    //Save products
    @IBAction func submitItemButtonPressed(_ sender: Any) {
        let alert = UIAlertController(
            title: "Submit Listing",
            message: "Are you sure you want to submit the listing?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            guard let description = self.descriptionTextField.text, let productName = self.productNameTextField.text else {
                print("Error: Some fields are empty")
                return
            }
            var data = [
                "productName": self.productNameTextField.text,
                "description": self.descriptionTextField.text,
                "startingPrice": self.startingPriceTextField.text,
                "minimumIncrement": self.minimumIncrementTextField.text,
                "buyItNow": self.buyItNowTextField.text,
                "timePeriod": self.timeTextField.text,
                "category": self.categoryTextField.text,
                "gender": self.genderTextField.text,
                "brand": self.brandTextField.text,
                "condition": self.conditionTextField.text,
                "imageUuid": self.imageUuid
            ]
            
            // Create a database reference
            let databaseRef = Database.Products.products.childByAutoId()

            // Create a child reference for "products" node
            let productsRef = databaseRef

            productsRef.setValue(data) { (error, ref) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("Data saved successfully!")
                    self.performSegue(withIdentifier: "unwindToHome", sender: nil)
                }
            }
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(alert, animated: true)

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("Image Not Found")
            return
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let xCoordinate = scrollView.frame.width * CGFloat(imageViews.count)
        imageView.frame = CGRect(x: xCoordinate, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        imageViews.append(imageView)
        
        // Remove all existing subviews from the scroll view
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        // Add image views from the array to the scroll view
        for (index, imageView) in imageViews.enumerated() {
            let xCoordinate = scrollView.frame.width * CGFloat(index)
            imageView.frame = CGRect(x: xCoordinate, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(imageView)
        }
        
        // Set the content size based on the number of image views
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageViews.count), height: scrollView.frame.height)
        
        // Update the number of pages on the page control
        pageControl.numberOfPages = imageViews.count
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to get JPEG data from image")
            return
        }
        
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert UIImage to Data")
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully")
                // You can access the download URL of the uploaded image like this:
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print("Error retrieving download URL: \(error.localizedDescription)")
                    } else {
                        guard let downloadURL = url else {
                            print("Download URL not found")
                            return
                        }
                        self.imageUuid = downloadURL.absoluteString // Update imageUuid with the download URL
                        
                        print("Image uploaded successfully! Download URL: \(downloadURL)")
                        print("Download URL: \(downloadURL.absoluteString)")
                    }
                })
            }
        }
    }
    
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
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
        
 
