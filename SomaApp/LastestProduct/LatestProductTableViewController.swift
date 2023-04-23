import UIKit
import Firebase
import FirebaseStorage


class LatestProductTableViewController: UITableViewController {
    
    var latestProducts: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.latestProducts = []
        fetchLatestProducts()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LatestProductTableViewCell

        // Retrieve the latest products
        guard !self.latestProducts.isEmpty else {
            return cell
        }

        let cellWidth = cell.contentView.frame.width
        let cellHeight = cell.contentView.frame.height

        // Display the latest 4 products
        for i in 0..<min(latestProducts.count, 4) {
            let x = CGFloat(i % 2) * (cellWidth / 2) + 8
            let y = CGFloat(i / 2) * (cellHeight / 2.5)  // Add spacing between rows

            // Create the product image view
            let productImageView = UIImageView(frame: CGRect(x: x, y: y, width: cellWidth / 2 - 15 , height: cellHeight * 0.3))
            productImageView.contentMode = .scaleAspectFill
            productImageView.clipsToBounds = true

            
            if let imageUrlString = latestProducts[i]["imageUuid"] as? String {
                downloadImage(imageUrlString: imageUrlString, imageView: productImageView)
            } else {
                productImageView.image = UIImage(named: "placeholder.png")
            }

            // Create the time period label
            let timePeriodLabel = UILabel(frame: CGRect(x: x + 4, y: y + productImageView.frame.height + 8, width: cellWidth / 2 - 8, height: 24))
            timePeriodLabel.font = UIFont.systemFont(ofSize: 16)

            // Set the time period label text
            let timePeriod = latestProducts[i]["timePeriod"] as? String ?? ""
            timePeriodLabel.text = timePeriod
            // Create the product name label
            let productNameLabel = UILabel(frame: CGRect(x: x + 4, y: y + productImageView.frame.height + timePeriodLabel.frame.height + 16, width: cellWidth / 2 - 8, height: 24))
            productNameLabel.font = UIFont.boldSystemFont(ofSize: 16)

            // Set the product name label text
            let productName = latestProducts[i]["productName"] as? String ?? ""
            productNameLabel.text = productName
            let brandLabel = UILabel(frame: CGRect(x: x + 4, y: y + productImageView.frame.height + timePeriodLabel.frame.height + productNameLabel.frame.height + 24, width: cellWidth / 2 - 8, height: 24))
            brandLabel.font = UIFont.systemFont(ofSize: 16)

            // Set the brand label text
            let brand = latestProducts[i]["brand"] as? String ?? ""
            brandLabel.text = brand
            // Create the current bid label
            let currentBidLabel = UILabel(frame: CGRect(x: x + 4, y: y + productImageView.frame.height + timePeriodLabel.frame.height + productNameLabel.frame.height + brandLabel.frame.height + 32, width: cellWidth / 2 - 8, height: 24))
            currentBidLabel.font = UIFont.systemFont(ofSize: 16)

            // Set the current bid label text
            let currentBid = latestProducts[i]["currentBid"] as? String ?? ""
            currentBidLabel.text = currentBid

            cell.contentView.addSubview(currentBidLabel)
            cell.contentView.addSubview(brandLabel)
            cell.contentView.addSubview(productNameLabel)
            cell.contentView.addSubview(productImageView)
            cell.contentView.addSubview(timePeriodLabel)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height * 0.9 // set the height of the row to 30% of the table view height
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
            
        }) { (error) in
            print(error.localizedDescription)
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
