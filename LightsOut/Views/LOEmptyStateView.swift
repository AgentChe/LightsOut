//
//  LOEmptyStateView.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 27.05.2022.
//

import UIKit

class LOEmptyStateView: UIView {
    
    let messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    private func configure() {
        addSubview(messageLabel)
        configureMessageLabel()
    }
    
    
    private func configureMessageLabel() {
        messageLabel.numberOfLines = 4
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = UIFont.systemFont(ofSize: 28)
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.9
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -70),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

}

