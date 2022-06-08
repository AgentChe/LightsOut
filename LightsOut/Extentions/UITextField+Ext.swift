//
//  UITextField+Ext.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

extension UITextField {
    func addDoneButton(button: UIBarButtonItem) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width:  UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items = [flexSpace, button]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
