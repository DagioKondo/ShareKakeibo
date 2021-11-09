//
//  GroupMemberViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class GroupMemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,LoadOKDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //追加
    var db = Firestore.firestore()
    var loadDBModel = LoadDBModel()
    var groupID = String()
    //変更
    var profileImageArray = [String]()
    var userNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        //追加
        groupID = UserDefaults.standard.object(forKey: "groupID") as! String
        loadDBModel.loadOKDelegate = self
        loadDBModel.loadGroupMember(groupID: groupID)
    }
  
    func loadGroupMember_OK(profileImageDic: Dictionary<String, String>, userNameDic: Dictionary<String, String>) {
        self.profileImageArray = Array(profileImageDic.values)
        self.userNameArray = Array(userNameDic.values)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cellView = cell.contentView.viewWithTag(1)
        let profileImage = cell.contentView.viewWithTag(2) as! UIImageView
        let userNameLabel = cell.contentView.viewWithTag(3) as! UILabel
        
        profileImage.sd_setImage(with: URL(string: userNameArray[indexPath.row]), completed: nil)
        profileImage.layer.cornerRadius = 30
        //追加
        userNameLabel.text = userNameArray[indexPath.row]
        cellView!.layer.cornerRadius = 5
        cellView!.layer.masksToBounds = false
        cellView!.layer.cornerRadius = 5
        cellView!.layer.shadowOffset = CGSize(width: 1, height: 1)
        cellView!.layer.shadowOpacity = 0.2
        cellView!.layer.shadowRadius = 1
        
        return cell
    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        // 削除のアクションを設定する
//        let deleteAction = UIContextualAction(style: .destructive, title:"delete") {
//            (ctxAction, view, completionHandler) in
//            self.userNameArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            completionHandler(true)
//        }
//        // 削除ボタンのデザインを設定する
//        let trashImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.white , renderingMode: .alwaysTemplate)
//        deleteAction.image = trashImage
//        deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
//
//        // スワイプでの削除を無効化して設定する
//        let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction])
//        swipeAction.performsFirstActionWithFullSwipe = false
//
//        return swipeAction
//
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
