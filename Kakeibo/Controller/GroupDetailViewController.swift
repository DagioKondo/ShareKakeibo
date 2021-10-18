//
//  GroupDetailViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit

class GroupDetailViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func groupConfigurationButton(_ sender: Any) {
        performSegue(withIdentifier: "GroupConfigurationVC", sender: nil)
    }
    
    @IBAction func memberButton(_ sender: Any) {
        performSegue(withIdentifier: "MemberVC", sender: nil)
    }
    
    @IBAction func invitationButton(_ sender: Any) {
        performSegue(withIdentifier: "AdditionVC", sender: nil)
    }
    
    @IBAction func exitButton(_ sender: Any) {
        
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
