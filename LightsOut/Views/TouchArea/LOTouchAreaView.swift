//
//  LOTouchAreaView.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

protocol LOTouchAreaDelegate: AnyObject {
    func startGame()
    func endGame()
}

class LOTouchAreaView: UIView {
    
    weak var touchAreaDelegate: LOTouchAreaDelegate?
    
    let touchAreaTopLabel = LOTouchAreaLabel(fontSize: 30)
    let touchAreaBottomLabel = LOTouchAreaLabel(fontSize: 14)
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 40
        configureStackView()
        configureHandleGesture()
    }
    
    private func configureStackView() {
        touchAreaTopLabel.text = LocalizedStrings.tapAndHold
        touchAreaBottomLabel.text = LocalizedStrings.tapAndHoldDescr
        
        stackView.addArrangedSubview(touchAreaTopLabel)
        stackView.addArrangedSubview(touchAreaBottomLabel)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10)])
    }
    
    private func configureHandleGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        let lifeCount = UserDefaults.standard.integer(forKey: Constants.Keys.lifeCount)
       
        if sender.state == .began{
            if lifeCount <= 0 {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                print("DEBUG: Error your have no life from touchareaView.")
                sender.state = .cancelled
                return
            }
            touchAreaDelegate?.startGame()
            stackView.isHidden = true
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        } else if sender.state == .ended {
            touchAreaDelegate?.endGame()
            stackView.isHidden = false
        }
    }
}
