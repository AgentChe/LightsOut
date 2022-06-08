//
//  LOCollectionHeaderView.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOCollectionHeaderView: UICollectionReusableView {
    
    static let headerId = "headerId"
    static let categoryHeaderId = "categoryHeaderId"
    
    let titleLabel = UILabel()
    let createButton = UIButton()
    let dashLabel = UILabel()
    let joinButton = UIButton()
    let generalStackView = UIStackView()
    let buttonsStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        generalStackView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureStackView() {
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(.systemRed, for: .normal)
        createButton.addTarget(self, action: #selector(handleCreateButton), for: .touchUpInside)
        
        joinButton.setTitle("Join", for: .normal)
        joinButton.setTitleColor(.systemRed, for: .normal)
        joinButton.addTarget(self, action: #selector(handleJoinButton), for: .touchUpInside)
        dashLabel.text = "|"
        dashLabel.backgroundColor = .red
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.addArrangedSubview(createButton)
        buttonsStackView.addArrangedSubview(dashLabel)
        buttonsStackView.addArrangedSubview(joinButton)
        buttonsStackView.backgroundColor = .blue
        buttonsStackView.alignment = .center
   

        
        titleLabel.backgroundColor = .yellow
        addSubview(generalStackView)

        generalStackView.axis = .horizontal
        generalStackView.distribution = .fillProportionally
        generalStackView.spacing = 50
        generalStackView.addArrangedSubview(titleLabel)
        generalStackView.addArrangedSubview(buttonsStackView)
        

        titleLabel.text = "Friends League"

    }
    
    @objc func handleCreateButton() {
        print("DEBUG: tapped create button")
    }
    
    @objc func handleJoinButton() {
        print("DEBUG: tapped join button")
    }
}
