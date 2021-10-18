//
//  GroupConfigurationViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit

class GroupConfigurationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeButton(_ sender: Any) {
//        let layerNumber = navigationController!.viewControllers.count
//        print(layerNumber)
//        self.navigationController?.popToViewController(navigationController!.viewControllers[layerNumber - 2], animated: true)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
       
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
