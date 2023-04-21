//
//  HomeTableViewController.swift
//  SomaApp
//
//  Created by iOSdev on 04/04/2023.
//

import UIKit

class HomeTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var contenMode: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForPersmission()
        
        contenMode.delegate = self
        contenMode.dataSource = self
        
        scrollView.delegate = self
        
        let imageWidth: CGFloat = 350.0
        let imageHeight: CGFloat = 300.0
        
        for image in 5...8 {
            let imageToDisplay = UIImage(named: "\(image).png)")
            let imageView = UIImageView(image: imageToDisplay)
            imageView.contentMode = .scaleAspectFill
            
            // Set the size of the image view
            imageView.frame = CGRect(x: scrollView.frame.width * CGFloat(image - 5), y: 0, width: imageWidth, height: imageHeight)
            let buttonView = UIButton(frame: CGRect(x: scrollView.frame.width * CGFloat(image - 5), y: 0, width: imageWidth, height: imageHeight))
            // Set the corner radius based on the image view's width and height
            imageView.layer.cornerRadius = 20.0
            imageView.clipsToBounds = true
            
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageViews.count), height: scrollView.frame.height)
        pageControl.numberOfPages = imageViews.count
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        pageControl.currentPage = pageIndex
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        // Configure the cell
        cell.imageView.image = UIImage(named: "Image\(indexPath.item + 1)")
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView?.layer.cornerRadius = 12.0
        cell.imageView?.clipsToBounds = true
        
        let button = UIButton(frame: cell.bounds)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button.tag = indexPath.item
        
        cell.addSubview(button)
        
        return cell
    }
    
    @objc func buttonTapped(sender: UIButton) {
        print("Button tapped for item \(sender.tag)")
        // Perform segue or other actions as needed
        if sender.tag != 2 {
            let ghadeerStoryboard = UIStoryboard(name: "GhadeerStoryboard", bundle: nil)
            guard let womenCategoriesVC = ghadeerStoryboard.instantiateViewController(withIdentifier: "womenCategories") as? WomenCategoriesViewController else {
                print("shouldnt push")
                return
            }
            print("should push")
            present(womenCategoriesVC, animated: true, completion: nil)
        }
        if sender.tag == 2 {
            let ghadeerStoryboard = UIStoryboard(name: "GhadeerStoryboard", bundle: nil)
            guard let menCategoriesVC = ghadeerStoryboard.instantiateViewController(withIdentifier: "menCategories") as? MenCategoriesViewController else {
                print("shouldnt push")
                return
            }
            print("should push")
            present(menCategoriesVC, animated: true, completion: nil)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 10) / 2
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func checkForPersmission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .denied:
                self.dispatchNotification()
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                })
            default:
                return
            }
        }
    }
    
    func dispatchNotification() {
        let identifier = "Soma App notification"
        let title = "Soma"
        let body = "New products have been listed, bid now!"
        let hour = 15
        let minute = 54
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
}
