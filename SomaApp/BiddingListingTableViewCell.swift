//
//  BiddingListingTableViewCell.swift
//  SomaApp
//
//  Created by iOSdev on 19/04/2023.
//

import UIKit

class BiddingListingTableViewCell: UITableViewCell {

    @IBOutlet var biddingImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var currentBid: UILabel!
    @IBOutlet var yourBid: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
