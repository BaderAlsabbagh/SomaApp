//
//  StartBidViewController.swift
//  SomaApp
//
//  Created by iOSdev on 09/04/2023.
//

import UIKit

class StartBidViewController: UIViewController {

    @IBOutlet weak var setBidTextField: UITextField!

    @IBOutlet weak var submitBid: UIButton!
    //    if let setBidTextfield.text as? Int {
    //        let setBidValue = setBidTextField.text
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func submitBidButtonPressed(_ sender: Any) {
        
        guard
            let setBidText = setBidTextField.text, !setBidText.isEmpty
        else {
            let alert = UIAlertController(
                title: "Invalid Request",
                message: "Please set a bid",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            self.present(alert, animated: true)
            return
        }
        
        validated = true
    }
    
    var validated = false {
        didSet {
            setBidTextField.text = validated ? "true" : "false"
            submitBid.isEnabled = validated
        }
    }
    
//    @IBAction func submitBidButton(_ sender: UIButton) {
//
//             let alert = UIAlertController(
//                 title: "Submit Bid",
//                 message: "Are you sure you want to submit the bid?",
//                 preferredStyle: .alert
//             )
//             alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
//             })
//
//             alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//
//             self.present(alert, animated: true)
//    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
