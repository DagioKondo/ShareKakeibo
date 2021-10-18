//
//  ViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/08.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }

    
    @IBAction func loginButton(_ sender: Any) {
        
        performSegue(withIdentifier: "ProfileVC", sender: nil)
        
    }
    

}



