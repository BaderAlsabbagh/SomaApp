//
//  DatabaseTestingViewController.swift
//  SomaApp
//
//  Created by iOSdev on 10/04/2023.
//

import UIKit

class DatabaseTestingViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Database.Users["KKL4J8i9LlONmS1veOqXC3j6d9r1/Email"].getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            print(snapshot?.value,"test")
            if let snapshot = snapshot?.value as? String {
                
                    self.nameLabel.text = snapshot
                }
            }
    }
    
   
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


