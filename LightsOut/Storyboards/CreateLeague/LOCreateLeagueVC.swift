//
//  LOCreateLeagueVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOCreateLeagueVC: UIViewController {
    
    var userUid: String?
    
    @IBOutlet var boxView: UIView!
    @IBOutlet var leagueNameTextfield: UITextField!
    @IBOutlet var passwordTextfiel: UITextField!
    
    @IBOutlet var createButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var isLeagueNameOk = false
    var isPasswordOk = false
    var leagueIdIsOk = false
    var password = 0
    var randomLeaagueID: Int? {
        didSet {
            FirebaseManager.shared.getLeagueDetails(leagueId: randomLeaagueID!) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.randomLeaagueID = Int.random(in: 10000...99999)
                case .failure(_):
                    self.leagueIdIsOk = true
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        boxView.layer.cornerRadius = 10
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        leagueNameTextfield.becomeFirstResponder()
        passwordTextfiel.delegate = self
        leagueNameTextfield.delegate = self
        
        
        
        let done: UIBarButtonItem = UIBarButtonItem(title: LocalizedAlertboxStrings.done, style: .done, target: self, action: #selector(self.doneButtonAction))
        passwordTextfiel.addDoneButton(button: done)
    }
    
    @objc func doneButtonAction()
    {
        passwordTextfiel.resignFirstResponder()
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        switch textField {
        case leagueNameTextfield:
            return newLength <= 12
        case passwordTextfiel:
            return newLength <= 4
        default:
            return true
        }
    }
    
    func checkValidation(textIn textField: UITextField) {
        guard let text = textField.text else { return }
        
        switch textField {
        case leagueNameTextfield:
            if text.count < 4 || text.count > 12 {
                isLeagueNameOk = false
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.systemRed.cgColor
            } else {
                isLeagueNameOk = true
                textField.layer.borderWidth = 0
                textField.layer.borderColor = UIColor.clear.cgColor
            }
        case passwordTextfiel:
            if text.count < 4 {
                isPasswordOk = false
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.systemRed.cgColor
            } else {
                isPasswordOk = true
                textField.layer.borderWidth = 0
                textField.layer.borderColor = UIColor.clear.cgColor
            }
        default:
            return
        }
        
        if isPasswordOk && isLeagueNameOk {
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidation(textIn: textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkValidation(textIn: textField)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        createButton.isEnabled = false
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
        if textField == leagueNameTextfield {
            textField.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == leagueNameTextfield {
            textField.resignFirstResponder()
            passwordTextfiel.becomeFirstResponder()
        } else if textField == passwordTextfiel {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondView = segue.destination as! LOCreatLeagueLoadingVC
        secondView.leagueId = randomLeaagueID
        secondView.leagueName = leagueNameTextfield.text
        secondView.leaguePassword = passwordTextfiel.text
        secondView.leagueOwnerUid = userUid
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func createButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if leagueIdIsOk {
            
            self.performSegue(withIdentifier: Constants.Segues.goToLoading, sender: self)
        }
        
        
        
    }
}


extension LOCreateLeagueVC: UITextFieldDelegate {
    
}
