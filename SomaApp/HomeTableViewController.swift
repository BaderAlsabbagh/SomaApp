//
//  HomeTableViewController.swift
//  SomaApp
//
//  Created by iOSdev on 04/04/2023.
//

import UIKit
import Firebase
import FirebaseStorage

class HomeTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var contenMode: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var latestImageView1: UIImageView!
    @IBOutlet weak var latestImageView2: UIImageView!
    @IBOutlet weak var latestImageView3: UIImageView!
    @IBOutlet weak var latestImageView4: UIImageView!
    
    @IBOutlet weak var brandLabel1: UILabel!
    @IBOutlet weak var brandLabel2: UILabel!
    @IBOutlet weak var brandLabel3: UILabel!
    @IBOutlet weak var brandLabel4: UILabel!
    
    @IBOutlet weak var timePeriodLabel1: UILabel!
    @IBOutlet weak var timePeriodLabel2: UILabel!
    @IBOutlet weak var timePeriodLabel3: UILabel!
    @IBOutlet weak var timePeriodLabel4: UILabel!
    
    @IBOutlet weak var startingPriceLabel1: UILabel!
    @IBOutlet weak var startingPriceLabel2: UILabel!
    @IBOutlet weak var startingPriceLabel3: UILabel!
    @IBOutlet weak var startingPriceLabel4: UILabel!
    
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var nameLabel3: UILabel!
    @IBOutlet weak var nameLabel4: UILabel!
    
    var imageViews = [UIImageView]()
    var latestProducts: [[String: Any]] = []
    
    var timer: Timer?
    let interval = 5.0 // interval in seconds
    
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
        
        latestImageView1.layer.cornerRadius = 15.0
        latestImageView1.clipsToBounds = true
        latestImageView2.layer.cornerRadius = 15.0
        latestImageView2.clipsToBounds = true
        latestImageView3.layer.cornerRadius = 15.0
        latestImageView3.clipsToBounds = true
        latestImageView4.layer.cornerRadius = 15.0
        latestImageView4.clipsToBounds = true

        fetchLatestProducts()
        updateLatestImages()
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateProducts), userInfo: nil, repeats: true)
    }
    
    @objc func updateProducts() {
        // Call the methods to fetch and update the latest products
        fetchLatestProducts()
        updateLatestImages()
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
    
    func fetchLatestProducts() {
        self.latestProducts = []
        
        // Query the database for all products sorted by timestamp in descending order
        Database.Products.products.queryOrdered(byChild: "timestamp").queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            // Retrieve the latest products
            let products = snapshot.children.allObjects as! [DataSnapshot]
            for productSnapshot in products.reversed() {
                guard let product = productSnapshot.value as? [String: Any] else {
                    continue
                }
                self.latestProducts.append(product)
            }
            
            print("Latest products: \(self.latestProducts)")
            
            self.tableView.reloadData() // reload table view data
            
            // Call the method to update the latest images
            self.updateLatestImages()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateLatestImages() {
        // Display the latest 4 products
        for i in 0..<min(latestProducts.count, 4) {
            
            if let imageUrlString = latestProducts[i]["imageUuid"] as? String {
                let imageView: UIImageView?
                let brandLabel: UILabel?
                let timePeriodLabel: UILabel?
                let startingPriceLabel: UILabel?
                let nameLabel: UILabel?
                
                // Assign the image to the corresponding image view based on the index
                switch i {
                case 0:
                    imageView = latestImageView1
                    brandLabel = self.brandLabel1
                    timePeriodLabel = self.timePeriodLabel1
                    startingPriceLabel = self.startingPriceLabel1
                    nameLabel = self.nameLabel1
                case 1:
                    imageView = latestImageView2
                    brandLabel = self.brandLabel2
                    timePeriodLabel = self.timePeriodLabel2
                    startingPriceLabel = self.startingPriceLabel2
                    nameLabel = self.nameLabel2
                case 2:
                    imageView = latestImageView3
                    brandLabel = self.brandLabel3
                    timePeriodLabel = self.timePeriodLabel3
                    startingPriceLabel = self.startingPriceLabel3
                    nameLabel = self.nameLabel3
                case 3:
                    imageView = latestImageView4
                    brandLabel = self.brandLabel4
                    timePeriodLabel = self.timePeriodLabel4
                    startingPriceLabel = self.startingPriceLabel4
                    nameLabel = self.nameLabel4
                default:
                    imageView = nil
                    brandLabel = nil
                    timePeriodLabel = nil
                    startingPriceLabel = nil
                    nameLabel = nil
                }
                
                if let imageView = imageView {
                    Database.Storage.loadImage(view: imageView, uuid: imageUrlString )
                    print(imageUrlString)
                }
                brandLabel?.text = latestProducts[i]["brand"] as? String ?? ""
                timePeriodLabel?.text = latestProducts[i]["timePeriod"] as? String ?? ""
                startingPriceLabel?.text = "BHD \(latestProducts[i]["startingPrice"]!)" as? String ?? ""
                nameLabel?.text = latestProducts[i]["productName"] as? String ?? ""
                
            } else {
                // Assign the placeholder image to the corresponding image view based on the index
                switch i {
                case 0:
                    latestImageView1.image = UIImage(named: "placeholder.png")
                case 1:
                    latestImageView2.image = UIImage(named: "placeholder.png")
                case 2:
                    latestImageView3.image = UIImage(named: "placeholder.png")
                case 3:
                    latestImageView4.image = UIImage(named: "placeholder.png")
                default:
                    break
                }
             
            }
            
        }

    }

    
    func downloadImage(imageUrlString: String, imageView: UIImageView) {
        guard let imageUrl = URL(string: imageUrlString) else {
            imageView.image = UIImage(named: "placeholder.png")
            return
        }
        let imageUuid = imageUrl.lastPathComponent
        let storageRef = Storage.storage().reference().child("images/\(imageUuid)")
        storageRef.downloadURL { url, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            if let url = url {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                        return
                    }
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }.resume()
            }
        }
    }
}
