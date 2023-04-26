//
//  ProfileTableViewController.swift
//  SomaApp
//
//  Created by iOSdev on 11/04/2023.
//

import UIKit
import Firebase
import FirebaseDatabase


class ProfileTableViewController: UITableViewController {
    
    @IBOutlet var Name: UILabel!
    
    @IBOutlet var Gender: UILabel!
    
    @IBOutlet var Address: UILabel!
    
    @IBOutlet var mobileNumber: UILabel!
    
    @IBOutlet var DOB: UILabel!
    
    @IBOutlet var Email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        let ref = FirebaseDatabase.Database.database(url: //"https://somaapp-a3768-default-rtdb.europe-west1.firebasedatabase.app/").reference()
//        
//        ref.child("your_child").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get the value of the snapshot
//            let value = snapshot.value as? String ?? ""
//            
//            // Set the text of the label to the value
//            self.Name.text = value
//            self.Gender.text = value
//            self.Address.text = value
//            self.mobileNumber.text = value
//            self.DOB.text = value
//            self.Email.text = value
//            
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
     
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
