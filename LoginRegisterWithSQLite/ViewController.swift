//
//  ViewController.swift
//  LoginRegisterWithSQLite
//
//  Created by SaiKiran Panuganti on 30/03/21.
//  Copyright © 2021 SaiKiran Panuganti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userID : UITextField!
    @IBOutlet weak var password : UITextField!
    @IBOutlet weak var loginButton : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }

    func setUpUI() {
        userID.backgroundColor = UIColor.lightGray
        password.backgroundColor = UIColor.lightGray
        
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        let userIdPlaceholder = NSAttributedString(string: "User ID", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        let passwordPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        userID.attributedPlaceholder = userIdPlaceholder
        password.attributedPlaceholder = passwordPlaceholder
        
        loginButton.layer.cornerRadius = 5.0
        loginButton.backgroundColor = UIColor.darkGray
        loginButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func loginTapped(_ sender : UIButton) {
        if let userid = userID.text, let password = password.text {
            DBHelper().insert(id: 0, uid: userid, password: password)
        }
    }
}

