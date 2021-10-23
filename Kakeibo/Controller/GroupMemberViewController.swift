//
//  GroupMemberViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit

class GroupMemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    
    @IBOutlet weak var tableView: UITableView!
    
    var userNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        userNameArray = ["大伍","まさし","西","とこ"]
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
        
        profileImage.layer.cornerRadius = 30
        userNameLabel.text = userNameArray[indexPath.row]
        cellView!.layer.cornerRadius = 5
        cellView!.layer.masksToBounds = false
        cellView!.layer.cornerRadius = 5
        cellView!.layer.shadowOffset = CGSize(width: 1, height: 1)
        cellView!.layer.shadowOpacity = 0.2
        cellView!.layer.shadowRadius = 1
        
        return cell
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
