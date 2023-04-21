//
//  AddProductTableViewController.swift
//  SomaApp
//
//  Created by iOSdev on 02/04/2023.
//
import UIKit
import Firebase

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
    
    // Array of image views to display in the scroll view
    var imageViews = [UIImageView]()
    
    let categories = ["Clothing", "Bags", "Footwear", "Eyewear", "Accessories", "Jewelry", "Other"]
    let genders = ["Male", "Female", "Both"]
    let times = ["1 Hour", "3 Hours", "6 Hours", "12 Hours", "1 Day", "3 Days", "7 Days"]
    
    var categoryPickerView = UIPickerView()
    var genderPickerView = UIPickerView()
    var timePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegate of the scroll view to self
        scrollView.delegate = self
        // Set the content size of the scroll view based on the number of image views
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageViews.count), height: scrollView.frame.height)
        // Set the number of pages on the page control
        pageControl.numberOfPages = imageViews.count
        
        categoryTextField.inputView = categoryPickerView
        genderTextField.inputView = genderPickerView
        timeTextField.inputView = timePickerView
        
        categoryTextField.placeholder = "Select Category"
        genderTextField.placeholder = "Select Gender"
        timeTextField.placeholder = "Select Time Period"
        
        categoryTextField.textAlignment = .center
        genderTextField.textAlignment = .center
        timeTextField.textAlignment = .center
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        
        categoryPickerView.tag = 1
        genderPickerView.tag = 2
        timePickerView.tag = 3
        
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
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
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
                "condition": self.conditionTextField.text
            ]
            
            // Create a database reference
            let databaseRef = Database.Products.products.childByAutoId()

            // Create a child reference for "products" node
            let productsRef = databaseRef

            // Set the values to be saved in the database
            // data = ["name": name, "email": email]

            // Save the data to the new child node
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
        
       
    

    

//        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
//
//        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
//            print("Error: Failed to get image data")
//            return
//        }
//
//        let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                print("Error: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            storageRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
//                    return
//                }
    
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch pickerView.tag {
            case 1:
                return categories.count
            case 2:
                return genders.count
            case 3:
                return times.count
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
            default:
                return
            }
        }
    }
 
