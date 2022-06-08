//
//  LOInstructionLabel.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOInstructionLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        font = .systemFont(ofSize: 18)
        textColor = .systemGray
    }
}
