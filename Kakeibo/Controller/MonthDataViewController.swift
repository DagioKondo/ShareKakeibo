//
//  MonthDataViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit


class MonthDataViewController: UIViewController,GoToVcDelegate {

    
    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    @IBOutlet weak var addPaymentButton: UIButton!
    @IBOutlet weak var configurationButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPaymentButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        addPaymentButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        addPaymentButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addPaymentButton.layer.shadowOpacity = 0.5
        addPaymentButton.layer.shadowRadius = 1
        
        configurationButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        configurationButton.layer.shadowOpacity = 0.7
        configurationButton.layer.shadowRadius = 1

        groupNameLabel.layer.shadowOpacity = 0.7
    }
    
    @objc func touchDown(_ sender:UIButton){
        buttonAnimatedModel.startAnimation(sender: sender)
        addPaymentButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        addPaymentButton.layer.shadowOpacity = 0
        addPaymentButton.layer.shadowRadius = 0
    }
    
    @objc func touchUpOutside(_ sender:UIButton){
        buttonAnimatedModel.endAnimation(sender: sender)
        addPaymentButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addPaymentButton.layer.shadowOpacity = 0.5
        addPaymentButton.layer.shadowRadius = 1
    }
    
    @IBAction func addPaymentButton(_ sender: Any) {
        buttonAnimatedModel.endAnimation(sender: sender as! UIButton)
        performSegue(withIdentifier: "paymentVC", sender: nil)
        addPaymentButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addPaymentButton.layer.shadowOpacity = 0.5
        addPaymentButton.layer.shadowRadius = 1
    }
    
    @IBAction func configurationButton(_ sender: Any) {
        let GroupDetailVC = storyboard?.instantiateViewController(identifier: "GroupDetailVC") as! GroupDetailViewController
        GroupDetailVC.goToVcDelegate = self
        present(GroupDetailVC, animated: true, completion: nil)
    }
    
    func goToVC(segueID: String) {
        performSegue(withIdentifier: segueID, sender: nil)
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
