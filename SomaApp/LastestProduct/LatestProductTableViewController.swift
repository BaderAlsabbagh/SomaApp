import UIKit
import Firebase
import FirebaseStorage

class LatestProductTableViewController: UITableViewController {

    var latestProduct: [String: Any]?
    var latestImage: UIImage?
    var latestProducts: [[String: Any]] = []
    var latestImages: [UIImage] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.latestProducts = []
        self.latestImages = []
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

                // Query the storage for all images sorted by timestamp in descending order
                let storageRef = Storage.storage().reference().child("images")

                // Query the storage for all images sorted by timestamp in descending order
                storageRef.list(maxResults: 4, completion: { (result, error) in
                    if let result = result {
                        let images = result.items
                        // Retrieve the latest images
                        for imageRef in images.reversed() {
                            imageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                                if let error = error {
                                    print("Error downloading image: \(error.localizedDescription)")
                                    return
                                }
                                if let data = data, let image = UIImage(data: data) {
                                    // Use the downloaded image
                                    self.latestImages.append(image)

                                    print("Latest image: \(image)")

                                    self.tableView.reloadData() // reload table view data
                                }
                            }
                        }
                    } else if let error = error {
                        print("Error querying storage: \(error.localizedDescription)")
                    }
                })
            }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LatestProductTableViewCell

            // Retrieve the latest products and images
        guard !self.latestProducts.isEmpty,
              !self.latestImages.isEmpty else {
            return cell
        }


            let cellWidth = cell.contentView.frame.width
            let cellHeight = cell.contentView.frame.height

            // Display the latest 4 products and images
            for i in 0..<min(latestProducts.count, 4) {
                let x = CGFloat(i % 2) * (cellWidth / 2) + 8
                let y = CGFloat(i / 2) * (cellHeight / 2.5)  // Add spacing between rows

                // Create the product image view
                let productImageView = UIImageView(frame: CGRect(x: x, y: y, width: cellWidth / 2 - 15 , height: cellHeight * 0.3))
                productImageView.contentMode = .scaleAspectFill
                productImageView.clipsToBounds = true

                // Set the product image
                let latestImage = latestImages[i % latestImages.count]
                productImageView.image = latestImage

                // Create the time period label
                let timePeriodLabel = UILabel(frame: CGRect(x: x + 4, y: y + productImageView.frame.height + 8, width: cellWidth / 2 - 8, height: 24))
                timePeriodLabel.font = UIFont.systemFont(ofSize: 16)

                // Set the time period label text
                let latestProduct = latestProducts[i % latestProducts.count]
                let timePeriod = latestProduct["timePeriod"] as? String ?? ""
                timePeriodLabel.text = timePeriod

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
}
