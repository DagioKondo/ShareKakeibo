//
//  PaymentViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit

class PaymentViewController: UIViewController {

    
    @IBOutlet weak var paymentConfirmedButton: UIButton!
    @IBOutlet weak var paymentNameTextField: UITextField!
    @IBOutlet weak var paymentDayTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentConfirmedButton.layer.cornerRadius = 5
    }
    
    @IBAction func paymentConfirmedButton(_ sender: Any) {
        
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
