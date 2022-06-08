//
//  LOInstructionView.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOInstructionView: UIView {

    let instructionLabel = LOInstructionLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()

    }
    
    
    private func configure() {
        layer.cornerRadius = 20
        
        addSubview(instructionLabel)
        NSLayoutConstraint.activate([
            instructionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            instructionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            instructionLabel.centerYAnchor.constraint(equalTo: centerYAnchor)

            
        ])
        
    }
    

    func changeLabel(with text: String) {
        instructionLabel.text = text
    }
    
    
    

}
