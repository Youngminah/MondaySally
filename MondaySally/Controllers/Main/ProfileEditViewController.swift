//
//  ProfileEditViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class ProfileEditViewController: UIViewController {

    @IBOutlet weak var photoSelectButton: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()

    }
    
    private func updateUI(){
        self.photoSelectButton.layer.borderWidth = 1
        self.photoSelectButton.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.photoSelectButton.clipsToBounds = true
        self.photoSelectButton.layer.cornerRadius = self.photoSelectButton.bounds.width/2
        self.photoSelectButton.layer.masksToBounds = true
        self.nickNameTextField.layer.cornerRadius = 4
        self.nickNameTextField.clipsToBounds = true
        self.nickNameTextField.setLeftPaddingPoints(16)
        self.phoneNumberTextField.layer.cornerRadius = 4
        self.phoneNumberTextField.clipsToBounds = true
        self.phoneNumberTextField.setLeftPaddingPoints(16)
        self.accountTextField.layer.cornerRadius = 4
        self.accountTextField.clipsToBounds = true
        self.accountTextField.setLeftPaddingPoints(16)
        self.emailTextField.layer.cornerRadius = 4
        self.emailTextField.clipsToBounds = true
        self.emailTextField.setLeftPaddingPoints(16)
        self.unselectedNickNameTextFieldUI()
        self.unselectedPhoneNumberTextFieldUI()
        self.unselectedAccountTextFieldUI()
        self.unselectedEmailTextFieldUI()
    }

    
    private func selectedNickNameTextFieldUI(){
        self.nickNameTextField.layer.borderWidth = 1
        self.nickNameTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
    }
    
    private func unselectedNickNameTextFieldUI(){
        self.nickNameTextField.layer.borderWidth = 0.5
        self.nickNameTextField.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    }
    
    private func selectedPhoneNumberTextFieldUI(){
        self.phoneNumberTextField.layer.borderWidth = 1
        self.phoneNumberTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
    }
    
    private func unselectedPhoneNumberTextFieldUI(){
        self.phoneNumberTextField.layer.borderWidth = 0.5
        self.phoneNumberTextField.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    }
    
    private func selectedAccountTextFieldUI(){
        self.accountTextField.layer.borderWidth = 1
        self.accountTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
    }
    
    private func unselectedAccountTextFieldUI(){
        self.accountTextField.layer.borderWidth = 0.5
        self.accountTextField.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    }
    
    private func selectedEmailTextFieldUI(){
        self.emailTextField.layer.borderWidth = 1
        self.emailTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
    }
    
    private func unselectedEmailTextFieldUI(){
        self.emailTextField.layer.borderWidth = 0.5
        self.emailTextField.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    }

}
