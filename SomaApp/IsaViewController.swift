//
//  ViewController.swift
//  SomaApp
//
//  Created by iOSdev on 26/03/2023.
//

import UIKit
import FirebaseAuth
import UserNotifications
class IsaViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
      

        
        // Do any additional setup after loading the view.
    }
    
    
//    func checkForPersmission() {
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.getNotificationSettings { settings in
//            switch settings.authorizationStatus {
//            case .authorized:
//                self.dispatchNotification()
//            case .denied:
//                self.dispatchNotification()
//            case .notDetermined:
//                notificationCenter.requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in
//                    if didAllow {
//                        self.dispatchNotification()
//                    }
//                })
//            default:
//                return
//            }
//        }
//    }
//
//    func dispatchNotification() {
//        let identifier = "Soma App notification"
//        let title = "Soma"
//        let body = "new products has been listed, bid now!"
//        let hour = 15
//        let minute = 12
//        let isDaily = true
//
//        let notificationCenter = UNUserNotificationCenter.current()
//
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//
//        let calendar = Calendar.current
//        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
//        dateComponents.hour = hour
//        dateComponents.minute = minute
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
//        notificationCenter.add(request)
//    }

    
    
    
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


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}






