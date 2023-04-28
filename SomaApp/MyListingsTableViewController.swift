import UIKit
import Firebase
import FirebaseStorage

class MyListingsTableViewController: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startingPriceLabel: UILabel!
    @IBOutlet weak var minimumIncrement: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var buyItNowLabel: UILabel!
    
    var productId: String?
    var product: [String: Any]?
    let storageRef = Storage.storage().reference().child("images")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the latest product
        retrieveLatestProduct()
        
        // Retrieve the latest image
        retrieveLatestImage()
    }
    
    func retrieveLatestProduct() {
        // Query the database for all products sorted by timestamp in descending order
        Database.Products.products.queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: { (snapshot) in
            // Retrieve the most recent product
            let products = snapshot.children.allObjects as! [DataSnapshot]
            let mostRecentProduct = products.last
            guard let productId = mostRecentProduct?.key, let product = mostRecentProduct?.value as? [String: Any] else {
                return
            }
            self.productId = productId
            self.product = product
            self.updateView()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveLatestImage() {
        // Query the storage for all images sorted by timestamp in descending order
        storageRef.list(maxResults: 1, completion: { (result, error) in
            if let result = result {
                let images = result.items
                // Retrieve the latest image
                if let imageRef = images.first {
                    imageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                        if let error = error {
                            print("Error downloading image: \(error.localizedDescription)")
                            return
                        }
                        if let data = data, let image = UIImage(data: data) {
                            // Use the downloaded image
                            self.imageView.image = image
                        }
                    }
                }
            } else if let error = error {
                print("Error querying storage: \(error.localizedDescription)")
            }
        })
    }
    
    func updateView() {
        // Update the view with the retrieved product details
        guard let product = self.product else {
            return
        }
        self.productNameLabel.text = product["productName"] as? String
        self.descriptionLabel.text = product["description"] as? String
        self.startingPriceLabel.text = product["startingPrice"] as? String
        self.minimumIncrement.text = product["minimumIncrement"] as? String
        self.categoryLabel.text = product["category"] as? String
        self.genderLabel.text = product["gender"] as? String
        self.buyItNowLabel.text = product["buyItNow"] as? String
        self.timePeriodLabel.text = product["timePeriod"] as? String
    }
    
}
