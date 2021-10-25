//
//  CreateGroupViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var fixedCostTextField: UITextField!
    @IBOutlet weak var settlementTextField: UITextField!
    @IBOutlet weak var searchUserButton: UIButton!
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchUserButton.layer.cornerRadius = 5
        searchUserButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        searchUserButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        
        createGroupButton.layer.cornerRadius = 5
        createGroupButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        createGroupButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
    }
    
    @objc func touchDown(_ sender:UIButton){
        buttonAnimatedModel.startAnimation(sender: sender)
    }
    
    @objc func touchUpOutside(_ sender:UIButton){
        buttonAnimatedModel.endAnimation(sender: sender)
    }
    
    @IBAction func searchUserButton(_ sender: Any) {
        buttonAnimatedModel.endAnimation(sender: sender as! UIButton)
//        performSegue(withIdentifier: "searchVC", sender: nil)
        let searchVC = storyboard?.instantiateViewController(identifier: "searchVC")
        searchVC!.isModalInPresentation = false
        self.present(searchVC!, animated: true, completion: nil)
    }
    
    @IBAction func createGroupButton(_ sender: Any) {
        buttonAnimatedModel.endAnimation(sender: sender as! UIButton)
    }
    
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
