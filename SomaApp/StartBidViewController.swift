//
//  StartBidViewController.swift
//  SomaApp
//
//  Created by iOSdev on 09/04/2023.
//

import UIKit

class StartBidViewController: UIViewController {

    @IBOutlet weak var setBidTextField: UITextField!
//    if let setBidTextfield.text as? Int {
//        let setBidValue = setBidTextField.text
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitBidButton(_ sender: UIButton) {
       
            let alert = UIAlertController(
                title: "Submit Bid",
                message: "Are you sure you want to submit the bid?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in

               // let viewController = UIImagePickerController()
               // viewController.sourceType = .photoLibrary
               // viewController.delegate = self
               // viewController.allowsEditing = true
               //  self.present(viewController, animated: true)
            })

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            self.present(alert, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
