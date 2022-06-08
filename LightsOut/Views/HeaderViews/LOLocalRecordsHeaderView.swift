//
//  LOLocalRecordsHeaderView.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

protocol LOLocalRecordsHeaderViewDelegate: AnyObject {
    func didTapAction()
}

class LOLocalRecordsHeaderView: UICollectionReusableView {
    
    weak var headerViewDelegate: LOLocalRecordsHeaderViewDelegate?
    
    static let reuseId = "headerView"
    @IBOutlet var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        configureTapGesture()
    }
    
    func setAvarageReactionTime(with avarageReactionTime: Double) {
        
        textLabel.text = "You avarage reaction time: \(avarageReactionTime.convertThreePointString())"
    }
    
    private func configureTapGesture() {
        let longPress = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(longPress)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        headerViewDelegate?.didTapAction()
    }
    
}
