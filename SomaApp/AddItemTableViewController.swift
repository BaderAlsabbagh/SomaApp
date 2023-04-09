//
//  AddItemTableViewController.swift
//  SomaApp
//
//  Created by iOSdev on 02/04/2023.
//

import UIKit

class AddItemTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var submitItem: UIButton!
    let categories = ["Clothing", "Bags", "Footwear", "Eyewear", "Accessories", "Jewelry", "Other"]
    
    let genders = ["Male", "Female", "Both"]
    
    let times = ["1 Hour", "3 Hours", "6 Hours", "12 Hours", "1 Day", "3 Days", "7 Days"]
    
    var categoryPickerView = UIPickerView()
    var genderPickerView = UIPickerView()
    var timePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    //submitItem.layer.cornerRadius = 17.0
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //Image Selection Code
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(
            title: "Upload Images",
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
            print("No image found")
            return
        }
        
        // print out the image size as a test
        //print(image.size)
        imageView.image = image
    }
    
    
    @IBAction func checkMarkButtonPressed(_ sender: Any) {
        
        guard
            let categoryTextField = categoryTextField.text, !categoryTextField.isEmpty
        else {
            let alert = UIAlertController(
                title: "Invalid Request",
                message: "Please fill all the empty fields",
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
    
}
    extension AddItemTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
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
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//
//    /*
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
//    */
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
