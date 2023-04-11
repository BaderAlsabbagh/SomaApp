import UIKit

class ScrollAddItemTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // IBOutlets for the scroll view and page control
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // Array of image views to display in the scroll view
    var imageViews = [UIImageView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate of the scroll view to self
        scrollView.delegate = self
        
        // Set the content size of the scroll view based on the number of image views
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageViews.count), height: scrollView.frame.height)
        
        // Set the number of pages on the page control
        pageControl.numberOfPages = imageViews.count
    }
    
    @IBAction func uploadImagesButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "",
            message: "Are you sure you want upload images?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            
            let viewController = UIImagePickerController()
            viewController.sourceType = .photoLibrary
            viewController.delegate = self
            viewController.allowsEditing = true
            self.present(viewController, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("Image Not Found")
            return
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let xCoordinate = scrollView.frame.width * CGFloat(imageViews.count)
        imageView.frame = CGRect(x: xCoordinate, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        imageViews.append(imageView)
        
        // Remove all existing subviews from the scroll view
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        // Add image views from the array to the scroll view
        for (index, imageView) in imageViews.enumerated() {
            let xCoordinate = scrollView.frame.width * CGFloat(index)
            imageView.frame = CGRect(x: xCoordinate, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(imageView)
        }
        
        // Set the content size based on the number of image views
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageViews.count), height: scrollView.frame.height)
        
        // Update the number of pages on the page control
        pageControl.numberOfPages = imageViews.count
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
}
