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
            print("DEBUG: show error email not allowed")
            //            presentAlertWithOk(title: LocalizedStrings.emailError, message: LocalizedErrorMessages.emailNotAllowed)
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["help@foytingo.com"])
        composer.setSubject("Feedback/Contact")
        composer.setMessageBody("Hello, ...", isHTML: false)
        
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
            print("DEBUG: Show sent alert")
            DispatchQueue.main.async {
                let ac = UIAlertController(title: "Contact", message: "You message succesfully sent", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
            break
        case .failed:
            print("DEBUG: Show failed alert")
            
            break
        @unknown default:
            break
        }
        
        controller.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true)
    }
}
