//
//  YourLeagueHeaderView.swift
//  LightsOut
//
//  Created by Murat Baykor on 9.06.2022.
//

import UIKit

protocol YourLeagueHeaderViewDelegate: AnyObject {
    func didTapAction()
}
class YourLeagueHeaderView: UICollectionReusableView {

    weak var headerViewDelegate: YourLeagueHeaderViewDelegate?
    
    static let reuseId = "headerView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        configureTapGesture()
    }
    
    private func configureTapGesture() {
        let longPress = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(longPress)
    }
    

    @objc func handleTap(sender: UITapGestureRecognizer){
        print("DEBUG: HandleTap")
        headerViewDelegate?.didTapAction()
    }
}
