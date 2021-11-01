//
//  NewGroupViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit
import FirebaseFirestore

class NewGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,LoadOKDelegate {

    
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //追加
    var loadDBModel = LoadDBModel()
    var db = Firestore.firestore()
    var myEmail = String()
    var groupID = String()
    
    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    
    //追加
    var groupNotJoinArray = [JoinGroupFalseSets]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        createGroupButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        createGroupButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        createGroupButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        createGroupButton.layer.shadowOpacity = 0.5
        createGroupButton.layer.shadowRadius = 1
        
        //追加
        myEmail = UserDefaults.standard.object(forKey: "myEmail") as! String
        loadDBModel.loadOKDelegate = self
        loadDBModel.loadGroupInfo(myEmail: myEmail)
    }
    
    //追加
    func loadGroupInfo_OK() {
        groupNotJoinArray = loadDBModel.joinGroupFalseSets
        tableView.reloadData()
    }
    
    @objc func touchDown(_ sender:UIButton){
        buttonAnimatedModel.startAnimation(sender: sender)
        createGroupButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        createGroupButton.layer.shadowOpacity = 0
        createGroupButton.layer.shadowRadius = 0
    }
    
    @objc func touchUpOutside(_ sender:UIButton){
        buttonAnimatedModel.endAnimation(sender: sender)
        createGroupButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        createGroupButton.layer.shadowOpacity = 0.5
        createGroupButton.layer.shadowRadius = 1
    }
    
    @IBAction func createGroupButton(_ sender: Any) {
        buttonAnimatedModel.endAnimation(sender: sender as! UIButton)
        let createGroupVC = storyboard?.instantiateViewController(identifier: "CreateGroupVC") as! CreateGroupViewController
        navigationController?.pushViewController(createGroupVC, animated: true)
        createGroupButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        createGroupButton.layer.shadowOpacity = 0.5
        createGroupButton.layer.shadowRadius = 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupNotJoinArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let invitationView = cell.contentView.viewWithTag(1)!
        let groupNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let joinButton = cell.contentView.viewWithTag(3) as! UIButton
        let rejectButton = cell.contentView.viewWithTag(4) as! UIButton
        
        cell.selectionStyle = .none //セルのハイライトを消している
        
        invitationView.layer.cornerRadius = 5
        invitationView.layer.masksToBounds = false
        invitationView.layer.cornerRadius = 5
        invitationView.layer.shadowOffset = CGSize(width: 1, height: 1)
        invitationView.layer.shadowOpacity = 0.2
        invitationView.layer.shadowRadius = 1
        
        groupNameLabel.text = groupNotJoinArray[indexPath.row].groupName
        
        joinButton.layer.cornerRadius = 3
        joinButton.addTarget(self, action: #selector(joinButton(_:)), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        joinButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        
        rejectButton.layer.cornerRadius = 3
        rejectButton.addTarget(self, action: #selector(rejectButton(_:)), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        rejectButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        
        return cell
    }
    
    @objc func joinButton(_ sender:UIButton){
        buttonAnimatedModel.endAnimation(sender: sender)
        print(sender.superview?.superview)
        print(sender.superview?.superview?.superview)
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        //追加
        groupID = groupNotJoinArray[indexPath!.row].groupID
        UserDefaults.standard.setValue(groupID, forKey: "groupID")
        db.collection(myEmail).document(groupID).updateData(["joinGroup" : true as Bool])
        performSegue(withIdentifier: "TabBarContoller", sender: nil)
    }
    
    @objc func rejectButton(_ sender:UIButton){
        buttonAnimatedModel.endAnimation(sender: sender)
        
        //追加
        db.collection(myEmail).document(groupID).delete()
        loadDBModel.loadGroupInfo(myEmail: myEmail)
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
