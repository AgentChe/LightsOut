//
//  LOBannerCell.swift
//  LightsOut
//
//  Created by Murat Baykor on 15.06.2022.
//

import UIKit
import GoogleMobileAds

class LOBannerCell: UICollectionViewCell {

    @IBOutlet var adView: GADBannerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        adView.adUnitID = Constants.TestKeys.banner
    }


}
