//
//  SubmitBidTableViewController.swift
//  SomaApp
//
//  Created by iOSdev on 10/04/2023.
//

import UIKit

class SubmitBidTableViewController: UITableViewController {

    @IBOutlet weak var setBidTextField: UITextField!
    
    @IBOutlet weak var submitBid: UIButton!
    //    if let setBidTextfield.text as? Int {
    //        let setBidValue = setBidTextField.text
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBid.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    @IBAction func submitBidButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(
            title: "Submit Bid",
            message: "Are you sure you want to submit the bid?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "toStartBid", sender: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
        return
    }
    
    
    var validated = false {
        didSet {
            setBidTextField.text = validated ? "\(setBidTextField.text!)" : "falsde"
            submitBid.isEnabled = validated
        }
    }
    
    @IBAction func setBidTextFieldEditingChanged(_ sender: UITextField) {
        submitBid.isEnabled = !sender.text!.isEmpty
    }
}
//
//    @IBAction func submitBidButton(_ sender: UIButton) {
//
//
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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



    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
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

