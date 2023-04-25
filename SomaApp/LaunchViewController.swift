//
//  LaunchViewController.swift
//  SomaApp
//
//  Created by iOSdev on 24/04/2023.
//

import UIKit

class LaunchViewController: UIViewController {
    
    private let imageView1: UIImageView = {
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        imageView1.image = UIImage(named: "4")
        return imageView1
    }()
    private let imageView2: UIImageView = {
        let imageView2 = UIImageView(frame: CGRect(x: 193, y: 293, width: 150, height: 150))
        imageView2.image = UIImage(named: "hammertransparent")
        return imageView2
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView1.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: self.animate)
    }
    
    private func animate() {
        // Add rotation animation to imageView2
        imageView2.rotate()
        
        UIView.animate(withDuration: 2, animations: {
            // do nothing here
            
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    
                })
                
                UIView.animate(withDuration: 2, animations: {
                    self.imageView1.alpha = 0
                    self.imageView2.alpha = 0
                }, completion: { _ in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarID") as! TabBarViewController
                    viewController.modalTransitionStyle = .crossDissolve
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)
                })
            }
        })
    }
}
extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: -Double.pi / 30)
        rotation.duration = 0.3
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
