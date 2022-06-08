//
//  LOSingleLightView.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOSingleLightView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    
    private func configure() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = layer.frame.size.height / 2
        
    }
    
    func turnRed() {
        backgroundColor = .systemRed
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func turnDefault() {
        backgroundColor = .secondarySystemBackground
    }
    
}
