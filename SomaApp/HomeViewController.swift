//
//  HomeViewController.swift
//  SomaApp
//
//  Created by iOSdev on 30/03/2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func signout(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "user_uid_key")
        } catch {
            print("Error siging out")
        }
        
        if UserDefaults.standard.object(forKey: "user_uid_key") == nil {
            let storyboard = UIStoryboard(name: "HomepageStoryboard", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "HomeTableViewControllerID") as! HomeTableViewController

            
            //navigationController?.popToRootViewController(animated: true)
            navigationController?.popViewController(animated: true)
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

}
