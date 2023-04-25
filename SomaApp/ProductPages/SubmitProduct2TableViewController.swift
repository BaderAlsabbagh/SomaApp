//
//  SubmitBidTableViewController.swift
//  SomaApp
//
//  Created by iOSdev on 10/04/2023.
//

import UIKit

class SubmitProduct2TableViewController: UITableViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var setBidTextField: UITextField!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var submitBid: UIButton!
    @IBOutlet weak var currentBidLabel: UILabel!
    @IBOutlet weak var latestBidLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var endDate: Date?
    var countdownTimer: Timer?
    //    if let setBidTextfield.text as? Int {
    //        let setBidValue = setBidTextField.text
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBid.isEnabled = false
        
        let imageUuid = "tissotWatch.png"
        ImportImage.shared.downloadImage(imageUuid: imageUuid) { [weak self] (image, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else if let image = image {
                self?.productImageView.image = image
            }
        }
    
        Database.Products["-NSs7VtqFlA-Ef7pKJ7u/productName"].getData { error, snapshotProductName in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let snapshotProductName = snapshotProductName?.value as? String {
                
                self.productNameLabel.text = snapshotProductName
            }
        }
        
        Database.Products["-NSs7VtqFlA-Ef7pKJ7u/currentBid"].getData { error, snapshotCurrentBid in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let snapshotCurrentBid = snapshotCurrentBid?.value as? String {
                
                self.currentBidLabel.text = snapshotCurrentBid + " BHD"
                self.latestBidLabel.text = snapshotCurrentBid + " BHD"
            }
        }
        // Create a database reference
        let productRef = Database.Products.products.child("-NSs7VtqFlA-Ef7pKJ7u")
        
        // Observe changes in the product node
        productRef.observe(.value) { (snapshot) in
            
            // Get the product data from the snapshot
            let productData = snapshot.value as? [String: Any] ?? [:]
        
            let productName = productData["productName"] as? String ?? "N/A"
            self.productNameLabel.text = "\(productName)"
            // Get the latest bid and update the label
            let latestBid = productData["latestBid"] as? String ?? "N/A"
            self.latestBidLabel.text = "\(latestBid) BHD"
            
            // Get the current bid and update the label
            let currentBid = productData["currentBid"] as? String ?? "N/A"
            self.currentBidLabel.text = "\(currentBid) BHD"
        }
        // Countdown
        let calendar = Calendar.current
        // Set the end date based on the selected duration
        endDate = Date().addingTimeInterval(getTimeInterval(forDuration: .oneHour))
        
        // Set up date formatter
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        // Start the countdown timer
        startCountdownTimer()
    }
    
    // Start the countdown timer
    func startCountdownTimer() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLeft), userInfo: nil, repeats: true)
    }
    
    // Calculate and update the time left label
    @objc func updateTimeLeft() {
        guard let endDate = endDate else {
            return
        }
        let currentDate = Date()
        let components = calendar.dateComponents([.hour, .minute, .second], from: currentDate, to: endDate)
        if let hours = components.hour, let minutes = components.minute, let seconds = components.second {
            timeLeftLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        if currentDate >= endDate {
            countdownTimer?.invalidate()
            timeLeftLabel.text = "00:00:00"
        }
    }
    
    // Get the time interval for the selected duration
    func getTimeInterval(forDuration duration: Duration) -> TimeInterval {
        switch duration {
        case .oneHour:
            return 3600
        case .threeHours:
            return 10800
        case .sixHours:
            return 21600
        case .twelveHours:
            return 43200
        case .oneDay:
            return 86400
        case .threeDays:
            return 259200
        case .sevenDays:
            return 604800
        }
    }
    
    // Enum for duration options
    enum Duration {
        case oneHour
        case threeHours
        case sixHours
        case twelveHours
        case oneDay
        case threeDays
        case sevenDays
    }
    
        // Do any additional setup after loading the view.
    
    
//    override func viewDidDisappear(_ animated: Bool) {
//        UpdateBid.updatedBid.bid = "5"
//    }
    @IBAction func submitBidButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(
            title: "Submit Bid",
            message: "Are you sure you want to submit the bid?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            UpdateBid.updatedBid.bid = self.currentBidLabel.text!
            self.saveBidToFirebase()
            self.performSegue(withIdentifier: "toStartBid", sender: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
        return
    }
    
    
    var validated = false {
        didSet {
            setBidTextField.text = validated ? "\(setBidTextField.text!)" : "false"
            submitBid.isEnabled = validated
        }
    }
    
    @IBAction func setBidTextFieldEditingChanged(_ sender: UITextField) {
        submitBid.isEnabled = !sender.text!.isEmpty
    }
    
    // Save Set Bid
    func saveBidToFirebase() {
        let bidData = [
            "currentBid": setBidTextField.text,
            "latestBid": setBidTextField.text
        ]
        // Create a database reference

        // Save the data to the new child node
        let productRef = Database.Products.products.child("-NSs7VtqFlA-Ef7pKJ7u")
            
            // Update the values of the existing product node with the new bid data
            productRef.updateChildValues(bidData) { (error, ref) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("Data updated successfully!")
                }
            }
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

