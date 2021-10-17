//
//  ProfileViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit

class ProfileViewController: UIViewController,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
   
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!//roomNameが反映されるテーブルビューだよ
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileView: UIView! //profileImageViewの後ろの白いビュー
    @IBOutlet weak var profileOrangeView: UIView!//profileImageViewの後ろのオレンジのビュー
    
    
    var configurationTableView = UITableView() //設定バーのテーブルビューだよ
    let configurationNameArray = ["プロフィールを変更","ログアウト"]
    let configurationImageArray = ["person.fill","exit"]
    let configurationLabel = UILabel()
    var swipeView = UIView()
    
    var groupNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        profileImageView.layer.cornerRadius = 40
        profileView.layer.cornerRadius = 42
        profileOrangeView.layer.cornerRadius = 44
        
        configurationTableView.tag = 0
        configurationTableView.frame = CGRect(x: view.frame.size.width, y: 100, width: 260, height: scrollView.frame.height - 100)
        configurationTableView.separatorStyle = .none
        configurationTableView.register(UINib(nibName: "ProfileConfigurationCell", bundle: nil), forCellReuseIdentifier: "ProfileConfigurationCell")
        configurationTableView.delegate = self
        configurationTableView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        configurationLabel.text = "設定"
        configurationLabel.frame = CGRect(x: view.frame.size.width + 100, y: 30, width: 60, height: 35)
        configurationLabel.font = UIFont.boldSystemFont(ofSize: 28.0)
        configurationLabel.textColor = .darkGray
        
        swipeView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        swipeView.backgroundColor = .darkGray
        swipeView.alpha = 0
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width + 260, height: scrollView.frame.size.height - 100)
        scrollView.addSubview(configurationTableView)
        scrollView.addSubview(configurationLabel)
        scrollView.addSubview(swipeView)
        
        groupNameArray = ["テラスハウス","daigo","kondo"]//あとで消す
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPath, animated: true)
        }else if let congigurationIndexPath = configurationTableView.indexPathForSelectedRow {
            configurationTableView.deselectRow(at: congigurationIndexPath, animated: true)
        }
    }
    
    //スクロール中に呼ばれる
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        swipeView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        swipeView.backgroundColor = .darkGray
        swipeView.alpha = (0.1 / 260) * scrollView.bounds.minX
        print(scrollView.bounds)
        print(scrollView.frame)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0{
            return 2
        }else{
            return groupNameArray.count
        }
            
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0{
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0{
            return 70
        }else{
            return 85
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0{
            let configurationCell = configurationTableView.dequeueReusableCell(withIdentifier: "ProfileConfigurationCell") as! ProfileConfigurationCell
            let configurationImageView = configurationCell.cellImageView
            let configurationLabel = configurationCell.label
            if indexPath.row == 0{
                configurationImageView!.image = UIImage(systemName: configurationImageArray[indexPath.row])
                configurationLabel?.text = configurationNameArray[indexPath.row]
            }else{
                configurationImageView!.image = UIImage(named: configurationImageArray[indexPath.row])
                configurationLabel?.text = configurationNameArray[indexPath.row]
            }
            return configurationCell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            let groupNameLabel = cell?.contentView.viewWithTag(2) as! UILabel
            let cellView = cell?.contentView.viewWithTag(3) as! UIView
            let groupImage = cell?.contentView.viewWithTag(4) as! UIImageView
            
            groupImage.layer.cornerRadius = 30
            groupNameLabel.text = groupNameArray[indexPath.row]
            cellView.layer.cornerRadius = 5
            cellView.layer.masksToBounds = false
            cellView.layer.cornerRadius = 5
            cellView.layer.shadowOffset = CGSize(width: 1, height: 1)
            cellView.layer.shadowOpacity = 0.2
            cellView.layer.shadowRadius = 1
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0{
            if indexPath.row == 0{
                let ProfileDetailVC = storyboard?.instantiateViewController(withIdentifier: "ProfileDetailVC") as! ProfileDetailViewController
                navigationController?.pushViewController(ProfileDetailVC, animated: true)
            }else if indexPath.row == 1{
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            let tabBarContoller = storyboard?.instantiateViewController(withIdentifier: "TabBarContoller") as! UITabBarController
            navigationController?.pushViewController(tabBarContoller, animated: true)
        }
    }
    
    
    @IBAction func notificationButton(_ sender: Any) {
        let notificationVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationViewController
        navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @IBAction func newGroupButton(_ sender: Any) {
        let newGroupVC = storyboard?.instantiateViewController(withIdentifier: "NewGroupVC") as! NewGroupViewController
        navigationController?.pushViewController(newGroupVC, animated: true)
    }
    
    @IBAction func configurationButton(_ sender: Any) {
        scrollToPage()
    }
    
    func scrollToPage() {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = 260
        self.scrollView.scrollRectToVisible(frame, animated: true)
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
