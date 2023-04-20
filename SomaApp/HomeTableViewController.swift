//
//  HomeTableViewController.swift
//  SomaApp
//
//  Created by iOSdev on 04/04/2023.
//

import UIKit

class HomeTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
 
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    
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
        
        return cell
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
        let body = "new products has been listed, bid now!"
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
    
    @IBOutlet weak var contenMode: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
//    var contentWidth: CGFloat = 2000.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 checkForPersmission()
        
        contenMode.delegate = self
        contenMode.dataSource = self
        
        scrollView.delegate = self
        
        let imageWidth: CGFloat = 350.0
        let imageHeight: CGFloat = 300.0
        let buttonWidth: CGFloat = 350.0
        let buttonHeight: CGFloat = 300.0
        
        
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
        }
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(4), height: scrollView.frame.height)
    }
        
//
//        for image in 5...8 {
//            let imageToDisplay = UIImage(named: "\(image).png)")
//            let imageView = UIImageView(image: imageToDisplay)
//            imageView.contentMode = .scaleAspectFit
//
//
//            scrollView.addSubview(imageView)
//            imageView.frame = CGRect(x: scrollView.frame.width * CGFloat(image - 5), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
//        }
//        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(4), height: scrollView.frame.height)
//    }
//
        
        
        
//        for image in 5...8 {
//            let imageToDisplay = UIImage(named: "\(image).png)")
//            let imageView = UIImageView(image: imageToDisplay)
//            imageView.contentMode = .scaleAspectFill
//            let xCoordinate = view.frame.midX + view.frame.width * CGFloat(image)
//            scrollView.addSubview(imageView)
//            imageView.frame = CGRect(x: xCoordinate - 2000, y: 0, width: 100, height: 100)
//        }
//        scrollView.contentSize = CGSize(width: 2000, height: 100)
//    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(view.frame.width))
    }
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
            let sourceViewController = unwindSegue.source
            // Use data from the view controller which initiated the unwind segue
        }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
