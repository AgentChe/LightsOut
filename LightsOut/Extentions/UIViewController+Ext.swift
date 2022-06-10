//
//  UIViewController+Ext.swift
//  LightsOut
//
//  Created by Murat Baykor on 10.06.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlertWithOk(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}
