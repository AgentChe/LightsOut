//
//  LOAddNameForLeagueVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 7.06.2022.
//

import UIKit
protocol LOAddNameForLeagueVCDelegate: AnyObject {
    func didTapSaveButton(name: String?)
}
class LOAddNameForLeagueVC: UIViewController {

    weak var delegate: LOAddNameForLeagueVCDelegate?
    
    @IBOutlet var boxView: UIView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        boxView.layer.cornerRadius = 10
        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        delegate?.didTapSaveButton(name: nameTextField.text)
        self.dismiss(animated: true)
        
    }
    
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    

}

extension LOAddNameForLeagueVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true}
        let newLength = text.count + string.count - range.length
        return newLength <= 12
    }
    
    func checkValidation(textIn textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.count < 4 || text.count > 12 {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemRed.cgColor
            saveButton.isEnabled = false
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            saveButton.isEnabled = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidation(textIn: textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkValidation(textIn: textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
