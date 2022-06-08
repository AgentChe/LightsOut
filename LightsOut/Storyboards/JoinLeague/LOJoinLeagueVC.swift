//
//  LOJoinLeagueVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOJoinLeagueVC: UIViewController {

    
    var userUid: String?
    var isLeagueNumberOk = false
    var isLeaguePasswordOk = false
    
    @IBOutlet var boxView: UIView!
    @IBOutlet var leagueNumberTextfield: UITextField!
    @IBOutlet var leaguePasswordTextfield: UITextField!
    @IBOutlet var joinButton: UIButton!
    
    @IBOutlet var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        boxView.layer.cornerRadius = 10
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        leagueNumberTextfield.becomeFirstResponder()
        leagueNumberTextfield.delegate = self
        leaguePasswordTextfield.delegate = self
        
        let next: UIBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.nextButtonAction))
        leagueNumberTextfield.addDoneButton(button: next)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        leaguePasswordTextfield.addDoneButton(button: done)
        
    }
    
    @objc func doneButtonAction()
    {
        leaguePasswordTextfield.resignFirstResponder()
    }
    
    @objc func nextButtonAction()
    {
        leagueNumberTextfield.resignFirstResponder()
        leaguePasswordTextfield.becomeFirstResponder()
    }
    
    @IBAction func joinButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "goToJoinLoading", sender: self)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondView = segue.destination as! LOJoinLeagueLoadingVC
        secondView.userUid = userUid
        secondView.leagueNumber = leagueNumberTextfield.text
        secondView.leaguePassword = leaguePasswordTextfield.text

    }
    
    func checkValidation(textIn textField: UITextField) {
        guard let text = textField.text else { return }
        
        switch textField {
        case leagueNumberTextfield:
            if text.count == 5 {
                isLeagueNumberOk = true
                textField.layer.borderWidth = 0
                textField.layer.borderColor = UIColor.clear.cgColor
            } else {
                isLeagueNumberOk = false
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.systemRed.cgColor
            }
        case leaguePasswordTextfield:
            if text.count == 4 {
                isLeaguePasswordOk = true
                textField.layer.borderWidth = 0
                textField.layer.borderColor = UIColor.clear.cgColor
            } else {
                isLeaguePasswordOk = false
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.systemRed.cgColor
            }
        default:
            return
        }
        
        if isLeaguePasswordOk && isLeagueNumberOk {
            joinButton.isEnabled = true
        } else {
            joinButton.isEnabled = false
        }
    }
    
    
}

extension LOJoinLeagueVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        switch textField {
        case leagueNumberTextfield:
            return newLength <= 5
        case leaguePasswordTextfield:
            return newLength <= 4
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        joinButton.isEnabled = false
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
//        if textField == leagueNumberTextfield {
//            textField.layer.borderColor = UIColor.clear.cgColor
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidation(textIn: textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkValidation(textIn: textField)
    }
    
    
    
}
