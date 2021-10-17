//
//  MonthDataViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit

class MonthDataViewController: UIViewController {

    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    @IBOutlet weak var addPaymentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPaymentButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        addPaymentButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
    }
    
    @objc func touchDown(_ sender:UIButton){
        buttonAnimatedModel.startAnimation(sender: sender)
    }
    
    @objc func touchUpOutside(_ sender:UIButton){
        buttonAnimatedModel.startAnimation(sender: sender)
    }
    
    
    @IBAction func addPaymentButton(_ sender: Any) {
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
