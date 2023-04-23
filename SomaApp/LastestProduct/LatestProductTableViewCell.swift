import UIKit

class LatestProductTableViewCell: UITableViewCell {

    var productImageViews = [UIImageView]()
    var timePeriodLabels = [UILabel]()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])

        let cellWidth = (UIScreen.main.bounds.width - 48) / 2
        let cellHeight = cellWidth * 1.3

        // Initialize the image views and time period labels
        for i in 0..<4 {
            let productImageView = UIImageView()
            productImageView.contentMode = .scaleAspectFill
            productImageView.clipsToBounds = true
            stackView.addArrangedSubview(productImageView)
            productImageViews.append(productImageView)

            let timePeriodLabel = UILabel()
            timePeriodLabel.font = UIFont.systemFont(ofSize: 12)
            timePeriodLabel.textAlignment = .center
            stackView.addArrangedSubview(timePeriodLabel)
            timePeriodLabels.append(timePeriodLabel)

            NSLayoutConstraint.activate([
                productImageView.widthAnchor.constraint(equalToConstant: cellWidth),
                productImageView.heightAnchor.constraint(equalToConstant: cellHeight * 0.7),

                timePeriodLabel.widthAnchor.constraint(equalToConstant: cellWidth),
                timePeriodLabel.heightAnchor.constraint(equalToConstant: cellHeight * 0.3),
            ])
        }
    }
}
