//
//  LOLifeView.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

protocol LOLifeViewDelegate: AnyObject {
    func didTapAddLifeButton()
}

enum LifeCase {
    case up, down
}

class LOLifeView: UIView {

    weak var lifeViewDelegate: LOLifeViewDelegate?
    
    let lifeImage = UIImageView()
    let lifeLabel = UILabel()
    let addLifeButton = UIButton()
    
    let stackview = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        configureStackView()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        addGestureRecognizer(tap)
    }
    
    private func configureStackView() {
        lifeImage.image = UIImage(systemName: "heart")
        lifeImage.tintColor = .systemRed
        lifeImage.contentMode = .scaleAspectFit
        
        lifeLabel.text = "0"
        lifeLabel.textColor = .systemGray
        lifeLabel.textAlignment = .center
        
        addLifeButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addLifeButton.tintColor = .systemRed
        addLifeButton.addTarget(self, action: #selector(handleLongPress(sender:)), for: .touchUpInside)
        
        stackview.addArrangedSubview(lifeImage)
        stackview.addArrangedSubview(lifeLabel)
        stackview.addArrangedSubview(addLifeButton)
        
        stackview.distribution = .fillEqually
        stackview.axis = .horizontal
        stackview.spacing = 0
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackview)
        
        NSLayoutConstraint.activate([stackview.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                     stackview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
                                     stackview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
                                     stackview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)])
        
    }
    
    
    func updateLifeLabel(with lifeCount: Int?){
        lifeLabel.text = "\(lifeCount ?? 9999)"
    }
    
    @objc func handleLongPress(sender: UITapGestureRecognizer) {
        lifeViewDelegate?.didTapAddLifeButton()
    }
    
    func lifeUpOrDownAnimation(lifeCase: LifeCase) {
        switch lifeCase {
        case .up:
            lifeImage.image = UIImage(systemName: "arrowtriangle.up.fill" )
            lifeImage.tintColor = .systemGreen
        case .down:
            lifeImage.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.125, options: [.curveEaseInOut]) {
            UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true) {
                self.lifeImage.alpha = 0
            }
        } completion: { (_) in
            self.lifeImage.image = UIImage(systemName: "heart")
            self.lifeImage.alpha = 1
            self.lifeImage.tintColor = .systemRed
        }

    }
}
