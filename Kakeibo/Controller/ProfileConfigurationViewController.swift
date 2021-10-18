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
    
    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    var receiveTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = receiveTitle
        textField.placeholder = receiveTitle
        saveButton.layer.cornerRadius = 5
        saveButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        saveButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
    }
    
    @objc func touchDown(_ sender:UIButton){
        buttonAnimatedModel.startAnimation(sender: sender)
    }
    
    @objc func touchUpOutside(_ sender:UIButton){
        buttonAnimatedModel.endAnimation(sender: sender)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        buttonAnimatedModel.endAnimation(sender: sender as! UIButton)
        let layerNumber = navigationController!.viewControllers.count
        print(layerNumber)
        self.navigationController?.popToViewController(navigationController!.viewControllers[layerNumber - 2], animated: true)
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
