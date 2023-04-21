import UIKit

class LatestProductTableViewCell: UITableViewCell {

    var productImageViews = [UIImageView]()
    var timePeriodLabels = [UILabel]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let cellWidth = UIScreen.main.bounds.width * 0.3
        let cellHeight = cellWidth * 1.3

        // Initialize the image views and time period labels
        for i in 0..<4 {
            let x = CGFloat(i % 2) * (cellWidth + 16) + 16
            let y = CGFloat(i / 2) * (cellHeight + 16) + 8

            let productImageView = UIImageView(frame: CGRect(x: x, y: y, width: cellWidth, height: cellHeight * 0.7))
            productImageView.contentMode = .scaleAspectFill
            productImageView.clipsToBounds = true
            contentView.addSubview(productImageView)
            productImageViews.append(productImageView)

            let timePeriodLabel = UILabel(frame: CGRect(x: x, y: y + productImageView.frame.height, width: cellWidth, height: cellHeight * 0.3))
            timePeriodLabel.font = UIFont.systemFont(ofSize: 12)
            contentView.addSubview(timePeriodLabel)
            timePeriodLabels.append(timePeriodLabel)
        }
    }

}
