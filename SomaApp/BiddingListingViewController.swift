//
//  BiddingListingViewController.swift
//  SomaApp
//
//  Created by iOSdev on 19/04/2023.
//

import UIKit

class BiddingListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var biddingData: [Bidding] = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segment: UISegmentedControl!
    
    var biddings = [Bidding]()
    var listings = [Listing]()
    
    let myBidding1 = Bidding(image: UIImage(named: "L1070963")!, title: "glasses", currentBid: "Current Bid: 143 BHD", yourBid: "Your Bid: 450 BHD")
    let myBidding2 = Bidding(image: UIImage(named: "best-bracelets-mens-1465x1099-c-center")!, title: "bracelet", currentBid: "Current Bid: 20 BHD", yourBid: "Your Bid: 20 BHD")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBiddingData()
        
        biddings.append(myBidding1)
        biddings.append(myBidding2)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0 {
            return biddings.count
        } else {
            return listings.count
        }
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        UITableViewCell()
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BiddingListingTableViewCell
        
        // Get the appropriate bidding or listing object based on the selected segment
        var object: Any?
        if segment.selectedSegmentIndex == 0 {
            object = biddings[indexPath.row]
        } else {
            object = listings[indexPath.row]
        }
        
        // Set the cell's properties based on the object
        if let bidding = object as? Bidding {
            cell.biddingImage.image = bidding.image
            cell.title.text = bidding.title
            cell.currentBid.text = bidding.currentBid
            cell.yourBid.text = bidding.yourBid
        } else if let listing = object as? Listing {
            // Set the cell's properties based on the listing object
        }
        
        return cell
    }
    

    // Function to fetch data from Firebase
    func fetchBiddingData() {
        //Load Image
        let imageUuid = "tissotWatch.png"
        ImportImage.shared.downloadImage(imageUuid: imageUuid) { [weak self] (image, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else if let image = image {
                // Fetch the data
                Database.Products.products.child("-NSs7VtqFlA-Ef7pKJ7u").observeSingleEvent(of: .value, with: { snapshot in
                    guard let data = snapshot.value as? [String: Any] else {
                        return
                    }
                    
                    // Create a Bidding object using the fetched data and downloaded image
                    let bidding = Bidding(image: image,
                                          title: data["productName"] as? String ?? "",
                                          currentBid: "Current Bid: \(data["currentBid"] as? String ?? "") BHD",
                                          yourBid: "Your Bid: \(data["currentBid"] as? String ?? "") BHD")
                    
                    // Append the Bidding object to the biddings array
                    self?.biddings.append(bidding)
                    
                    // Reload the data in your table view or collection view
                    self?.tableView.reloadData()
                }) { error in
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
    }
}
