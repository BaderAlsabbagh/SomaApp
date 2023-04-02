//
//  ViewController.swift
//  SomaApp
//
//  Created by iOSdev on 26/03/2023.
//

import UIKit
import FirebaseAuth

class IsaViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var usernameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    
    @IBAction func login(_ sender: UIButton) {
        
        guard let username = usernameField.text, !username.isEmpty, let password = passwordField.text, !password.isEmpty else {
            print("missing field data")
            
            let alert = UIAlertController(title:"Missing Field data", message: "please fill in the required fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            self.present(alert, animated: true)
            
            return
        }
            
        FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password, completion: {[weak self] result, error in guard let self = self else {return}
            
            guard error == nil else {
                print("Invalid credentials!")
                let alert = UIAlertController(title: "Invalid credentials!", message: "please try again", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                self.present(alert, animated: true)
                
                return
            }
            
            UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "user_uid_key")
            
            self.performSegue(withIdentifier: "Home", sender: sender)

        })
        
        

        
     

            
        }
    }




