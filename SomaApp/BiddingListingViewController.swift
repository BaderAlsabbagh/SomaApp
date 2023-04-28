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
    
    let myBidding1 = Bidding(image: UIImage(named: "tissotWatch")!, title: "Tissot Watch", yourBid: "Your Bid: 130 BHD")
    let myBidding2 = Bidding(image: UIImage(named: "IMG_4906")!, title: "Hermes Shoes", yourBid: "Your Bid: 150 BHD")
    let myListing1 = Listing(image: UIImage(named: "men-sunglasses-500x500.jpg")!, title: "My Glasses", PriceSold: "55 BHD", yourBid: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchBiddingData(forImageUuid: "bag1.jpeg", childNode: "-NSuT8UljmhwFz4t9GYt")
//        fetchBiddingData(forImageUuid: "watch1.jpeg", childNode: "-NSutl7WwKeAFcyF_-6n")
//        fetchBiddingData(forImageUuid: "shoe1.jpeg", childNode: "-NTJ_Vq7WnfvvVejA3bL")
//        fetchListingData(forImageUuid: "glasses1.jpeg", childNode: "-NSuftOZaGStReVyBnHK")
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
            cell.yourBid.text = bidding.yourBid
        } else if let listing = object as? Listing {
            cell.biddingImage.image = listing.image
            cell.title.text = listing.title
            cell.currentBid.text = listing.PriceSold
            
        }
        
        return cell
    }
    
    
    // Function to fetch data from Firebase
    func fetchBiddingData(forImageUuid imageUuid: String, childNode: String) {
        ImportImage.shared.downloadImage(imageUuid: imageUuid) { [weak self] (image, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else if let image = image {
                Database.Products.products.child(childNode).observeSingleEvent(of: .value, with: { snapshot in
                    guard let data = snapshot.value as? [String: Any] else {
                        return
                    }
                    
                    let bidding = Bidding(image: image,
                                          title: data["productName"] as? String ?? "",
                                          yourBid: "Your Bid: \(Int.random(in: 60...100)) BHD")
                    
                    self?.biddings.append(bidding)
                    self?.tableView.reloadData()
                }) { error in
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    func fetchListingData(forImageUuid imageUuid: String, childNode: String) {
        ImportImage.shared.downloadImage(imageUuid: imageUuid) { [weak self] (image, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else if let image = image {
                Database.Products.products.child(childNode).observeSingleEvent(of: .value, with: { snapshot in
                    guard let data = snapshot.value as? [String: Any] else {
                        return
                    }
                    
                    let listing = Listing(image: image, title: data["productName"] as! String, PriceSold: "Starting Price: \(data["currentBid"])", yourBid: "")
                    self?.listings.append(listing)
                    self?.tableView.reloadData()
                }) { error in
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
   

   
   

