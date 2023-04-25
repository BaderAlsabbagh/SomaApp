//
//  Product1TableViewController.swift
//  SomaApp
//
//  Created by Yousif Isa Shamtoot on 25/04/2023.
//

import UIKit

class StartProduct2TableViewController: UITableViewController {

        @IBOutlet weak var productImageView: UIImageView!
        @IBOutlet weak var productNameLabel: UILabel!
        @IBOutlet weak var productDescriptionLabel: UILabel!
        @IBOutlet weak var currentBidLabel: UILabel!
        @IBOutlet weak var timeLeftLabel: UILabel!
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        var endDate: Date?
        var countdownTimer: Timer?
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
   
            // Countdown
            let calendar = Calendar.current
            // Set the end date based on the selected duration
            endDate = Date().addingTimeInterval(getTimeInterval(forDuration: .threeHours))
            
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
        
        
        
        @IBAction func unwindToBidView(_ unwindSegue: UIStoryboardSegue) {
            let sourceViewController = unwindSegue.source
            // Use data from the view controller which initiated the unwind segue
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


