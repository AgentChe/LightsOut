//
//  GetProVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 31.05.2022.
//

import UIKit

class GetProVC: UIViewController {

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UITextView!
    
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var restoreButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.layer.cornerRadius = 10
        descriptionLabel.text = "Add-free experience\nUnlimited life\nAccess Friend Leagues"
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
