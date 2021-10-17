//
//  ProfileDetailViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit

class ProfileDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = ["名前","メールアドレス","パスワード"]
    var loadArray = [String]()
    var sendString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = 120
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        loadArray = ["近藤大伍","daigo.soccer.0106@icloud.com","Daigo0811"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let loadLabel = cell.contentView.viewWithTag(2) as! UILabel
        let imageView = cell.contentView.viewWithTag(3) as! UIImageView
        
        nameLabel.text = nameArray[indexPath.row]
        loadLabel.text = loadArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendString = nameArray[indexPath.row]
        performSegue(withIdentifier: "ProfileConfigurationVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ProfileConfigurationVC = segue.destination as! ProfileConfigurationViewController
        ProfileConfigurationVC.receiveTitle = sendString
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
