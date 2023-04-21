//
//  EditProfileTVC.swift
//  SomaApp
//
//  Created by iOSdev on 09/04/2023.
//

import Foundation
import UIKit
import Firebase

class EditProfileTVC: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var gender: UIPickerView!
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var Name: UITextField!
    
    @IBOutlet var Email: UITextField!
    
    @IBOutlet var Address: UITextField!
    
    @IBOutlet var Mobile: UITextField!
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var DOB: UIDatePicker!
    
    let genders = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    @IBAction func saveItemButtonPressed(_ sender: Any) {
        guard let Emailtext = Email.text, let Nametext = Name.text, let UsernameText = username.text, let MobileText = Mobile.text, let AddressText = Address.text else {
            print("Error: Some fields are empty")
            return
        }
        let data = ["Name": Nametext,
                    "Email": Emailtext,
                    "Username": UsernameText,
                    "DOB": "\(DOB.date)",
                    "Gender":genders[gender.selectedRow(inComponent: 0)],
                    "Mobile": MobileText,
                    "Address": AddressText]
        
        // Create a database reference
        let databaseRef = Database.Products.products.childByAutoId()
        
        // Create a child reference for "products" node
        let profileRef = databaseRef
        
        // Set the values to be saved in the database
        //data = ["name": name, "email": email]
        
        // Save the data to the new child node
        profileRef.setValue(data) { (error, ref) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Data saved successfully!")
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
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    //  }
    
    
    //}
}
