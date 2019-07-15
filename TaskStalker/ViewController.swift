//
//  ViewController.swift
//  TaskStalker
//
//  Created by Jolanta Zakrzewska on 13/07/2019.
//  Copyright © 2019 Jolanta Zakrzewska. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMaximumDismissTimeInterval(3)

    }

    @IBAction func registerButtonClicked(_ sender: Any) {
        SVProgressHUD.show()
        if areFieldsNotEmpty() {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
                SVProgressHUD.dismiss()
                guard let _ = authResult?.user, error == nil else {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "goNextAfterLogin", sender: self)
            }
        } else {
            SVProgressHUD.showError(withStatus: "You missed some fields...")
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        SVProgressHUD.show()
        if areFieldsNotEmpty() {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] user, error in
                SVProgressHUD.dismiss()
                guard error == nil else {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    return
                }
                
                self!.performSegue(withIdentifier: "goNextAfterLogin", sender: self)
            }
        } else {
            SVProgressHUD.showError(withStatus: "You missed some fields...")
        }
    }
    
    func areFieldsNotEmpty() -> Bool {
        var flag: Bool = true
        
        if let passwordText = self.password.text {
            if passwordText.isEmpty {
                flag = false
                self.password.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        }
        
        if let emailText = self.email.text {
            if emailText.isEmpty {
                flag = false
                self.email.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        }

        return flag
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func emailNotEmpty(_ sender: Any) {
        self.email.backgroundColor = nil
    }
    
    
    @IBAction func passwordNotEmpty(_ sender: Any) {
        self.password.backgroundColor = nil
    }
}

