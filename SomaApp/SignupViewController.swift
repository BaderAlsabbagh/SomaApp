//
//  SignupViewController.swift
//  SomaApp
//
//  Created by iOSdev on 30/03/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase



class SignupViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        firstName.delegate = self
        firstName.tag = 0
        lastName.tag = 1
        Username.tag = 2
        email.tag = 3
        password.tag = 4
        
        
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var firstName: UITextField!
    
    @IBOutlet var Username: UITextField!
    
    @IBOutlet var lastName: UITextField!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var password: UITextField!
    

    
    @IBAction func signUp(_ sender: UIButton) {
        
        
        
        guard let username = email.text, !username.isEmpty, let password = password.text, !password.isEmpty else {
            print("missing field data")
            
            let alert = UIAlertController(title:"Missing Field data", message: "please fill in the required fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            self.present(alert, animated: true)
            
            return
        }
        
                FirebaseAuth.Auth.auth().createUser(withEmail: username, password: password, completion: {[weak self] result, error in guard let self = self else { return}
        
                    guard error == nil else {
                        print(error ?? "")
        
        
                        let alert = UIAlertController(title: "Error", message: "Sign up failed", preferredStyle: .alert)
        
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
                        self.present(alert, animated: true)
        
                        return
                    }
                    
//                    database thing
                    let name = self.firstName.text! + " " + self.lastName.text!
                    let ref = FirebaseDatabase.Database.database(url: "https://somaapp-a3768-default-rtdb.europe-west1.firebasedatabase.app/").reference()
                    let uid = Auth.auth().currentUser?.uid
                    ref.child("users").child(uid!).setValue(["Email" : username, "Name" : name])
                    
                    
//                    presenting an alert
                    let alert = UIAlertController(title: "Success", message: "Account successfully created", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in self.navigationController?.popToRootViewController(animated: true)}))

                    self.present(alert, animated: true)

                    self.navigationController?.popToRootViewController(animated: true)
                    
                    
                    
                })
            }
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          // Try to find next responder
        textField.resignFirstResponder()
           let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField
             nextField?.becomeFirstResponder()
          
             // Not found, so remove keyboard.
             
          
          // Do not add a line break
          return false
       }
    
   
    
    
    
    
    }
    
    
    
   
    


