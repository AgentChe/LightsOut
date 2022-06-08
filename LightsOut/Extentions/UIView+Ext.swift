//
//  UIView+Ext.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }
}
