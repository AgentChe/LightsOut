//
//  FeedbackVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit
import MessageUI

class FeedbackVC: UIViewController {
    
    @IBOutlet var createMessageButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func createMessageButtonAction(_ sender: Any) {
        showMailComposer()
    }
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: LocalizedAlertboxStrings.emailError)
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["help@foytingo.com"])
        composer.setSubject(LocalizedStrings.contactCell)
        composer.setMessageBody(LocalizedStrings.emailPlaceholder, isHTML: false)
        
        present(composer, animated: true)
    }
    
}

extension FeedbackVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
            return
        }
        switch result {
        case .cancelled: break
        case .saved: break
        case .sent:
            DispatchQueue.main.async {
                let ac = UIAlertController(title: LocalizedAlertboxStrings.contact, message: LocalizedAlertboxStrings.contactSuccess, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.ok, style: .default))
                self.present(ac, animated: true)
            }
            break
        case .failed:
            DispatchQueue.main.async {
                let ac = UIAlertController(title: LocalizedAlertboxStrings.contact, message: LocalizedAlertboxStrings.contactError, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.ok, style: .default))
                self.present(ac, animated: true)
            }
            
            break
        @unknown default:
            break
        }
        
        controller.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}
