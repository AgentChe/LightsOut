//
//  LOLeaguesHeaderView.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

protocol LOLeaguesHeaderViewDelegate: AnyObject {
    func didTapCreateButton()
    func didTapJoinButton()
}

class LOLeaguesHeaderView: UICollectionReusableView {

    weak var delegate: LOLeaguesHeaderViewDelegate?
    
    @IBOutlet var joinButton: UIButton!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func crateButtonAction(_ sender: UIButton) {
        delegate?.didTapCreateButton()
    }
    @IBAction func joinButtonAction(_ sender: UIButton) {
        delegate?.didTapJoinButton()
    }
}
