//
//  MyListingsTableViewController.swift
//  SomaApp
//
//  Created by iOSdev on 13/04/2023.
//

import UIKit

class MyListingsTableViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    
 
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startingPriceLabel: UILabel!
    @IBOutlet weak var minimumIncrement: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var buyItNowLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        Database.Products["-NSs7VtqFlA-Ef7pKJ7u/productName"].getData { error, snapshotProductName in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let snapshotProductName = snapshotProductName?.value as? String {
                
                self.productNameLabel.text = snapshotProductName
            }
        }
        Database.Products["-NSs7VtqFlA-Ef7pKJ7u/description"].getData { error, snapshotDescription in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let snapshotDescription = snapshotDescription?.value as? String {
                
                self.descriptionLabel.text = snapshotDescription
            }
        }
        Database.Products["-NSs7VtqFlA-Ef7pKJ7u/startingPrice"].getData { error, snapshotStartingPrice in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let snapshotStartingPrice = snapshotStartingPrice?.value as? String {
                
                self.startingPriceLabel.text = snapshotStartingPrice
            }
        }
        Database.Products["-NSs7VtqFlA-Ef7pKJ7u/minimumIncrement"].getData { error, snapshotMinimumIncrement in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let snapshotMinimumIncrement = snapshotMinimumIncrement?.value as? String {
                
                self.minimumIncrement.text = snapshotMinimumIncrement
            }
        }
        Database.Products["-NSs7VtqFlA-Ef7pKJ7u/category"].getData { error, snapshotCategory in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let snapshotCategory = snapshotCategory?.value as? String {
                
                self.categoryLabel.text = snapshotCategory
            }
        }
        Database.Products["-NSs7VtqFlA-Ef7pKJ7u/gender"].getData { error, snapshotGender in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let snapshotGender = snapshotGender?.value as? String {
                
                self.genderLabel.text = snapshotGender
            }
        }
        Database.Products["-NSs7VtqFlA-Ef7pKJ7u/buyItNow"].getData { error, snapshotBuyItNow in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let snapshotBuyItNow = snapshotBuyItNow?.value as? String {
                
                self.buyItNowLabel.text = snapshotBuyItNow
            }
        }
        Database.Products["-NSs7VtqFlA-Ef7pKJ7u/timePeriod"].getData { error, snapshotTimePeriod in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let snapshotTimePeriod = snapshotTimePeriod?.value as? String {
                
                self.timePeriodLabel.text = snapshotTimePeriod
            }
        }
        
    
        
        
        //Image Code
        let imageUuid = "tissotWatch.png"
                ImportImage.shared.downloadImage(imageUuid: imageUuid) { [weak self] (image, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else if let image = image {
                        self?.imageView.image = image
                    }
                }
            }
        }
     
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    

    // MARK: - Table view data source

    

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


