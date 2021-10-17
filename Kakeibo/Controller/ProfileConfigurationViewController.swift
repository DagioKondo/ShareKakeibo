//
//  ProfileConfigurationViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit

class ProfileConfigurationViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var receiveTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = receiveTitle
        textField.placeholder = receiveTitle
        saveButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let layerNumber = navigationController!.viewControllers.count
        self.navigationController?.popToViewController(navigationController!.viewControllers[layerNumber - 3], animated: true)
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
