//
//  DetailAllViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/20.
//

import UIKit
import SDWebImage

class DetailAllViewController: UIViewController{
    
    var loadDBModel = LoadDBModel()
    var monthGroupDetailsSets = [MonthGroupDetailsSets]()
    var activityIndicatorView = UIActivityIndicatorView()
    var groupID = String()
    let dateFormatter = DateFormatter()
    var year = String()
    var month = String()
    var startDate = Date()
    var endDate = Date()
    var tableView = UITableView()
    //追加、変更
    var userIDArray = [String]()
    //追加
    var profileImage = String()
    var profileImageArray = [String]()
    var userNameArray = [String]()
    
    var settlementDay = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "detailCell")
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.view.addSubview(tableView)
        
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .large
        activityIndicatorView.color = .darkGray
        view.addSubview(activityIndicatorView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.dateComponents([.year,.month], from: Date())
        year = String(date.year!)
        month = String(date.month!)
        groupID = UserDefaults.standard.object(forKey: "groupID") as! String
        loadDBModel.loadOKDelegate = self
        
        activityIndicatorView.stopAnimating()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        self.settlementDay = UserDefaults.standard.object(forKey: "settlementDay") as! String
        if month == "12"{
            startDate = dateFormatter.date(from: "\(year)年\(month)月\(settlementDay)日")!
            endDate = dateFormatter.date(from: "\(String(Int(year)! + 1))年\("1")月\(settlementDay)日")!
        }else{
            startDate = dateFormatter.date(from: "\(year)年\(String(Int(month)! - 1))月\(settlementDay)日")!
            endDate = dateFormatter.date(from: "\(year)年\((month))月\(settlementDay)日")!
        }
        loadDBModel.loadMonthDetails(groupID: groupID, startDate: startDate, endDate: endDate, userID: nil, activityIndicatorView: activityIndicatorView)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//       
//        monthGroupDetailsSets = []
//    }


}

// MARK: - LoadOKDelegate
extension DetailAllViewController:LoadOKDelegate {
    
    //全体の明細を取得完了
    func loadMonthDetails_OK() {
        activityIndicatorView.stopAnimating()
        monthGroupDetailsSets = []
        monthGroupDetailsSets = loadDBModel.monthGroupDetailsSets
        //変更
        userIDArray = []
        profileImageArray = []
        userNameArray = []
        if monthGroupDetailsSets.count != 0{
            for i in 0...monthGroupDetailsSets.count - 1{
                userIDArray.append(monthGroupDetailsSets[i].userID)
            }
        }else{
            tableView.delegate = self
            tableView.dataSource = self
            self.tableView.reloadData()
        }
      
        //明細に表示するユーザーネームとプロフィール画像取得
        loadDBModel.loadGroupMember(userIDArray: userIDArray) { [self] UserSets in
            self.profileImageArray.append(UserSets.profileImage)
            self.userNameArray.append(UserSets.userName)
            
            tableView.delegate = self
            tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - TableView
extension DetailAllViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileImageArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
        //変更
        print(monthGroupDetailsSets)
        print(profileImageArray)
        if profileImageArray.count == monthGroupDetailsSets.count{
            cell.profileImage.sd_setImage(with: URL(string: profileImageArray[indexPath.row]), completed: nil)
            cell.paymentLabel.text = String(monthGroupDetailsSets[indexPath.row].paymentAmount)
            cell.userNameLabel.text = userNameArray[indexPath.row]
            cell.dateLabel.text = monthGroupDetailsSets[indexPath.row].paymentDay
            cell.category.text = monthGroupDetailsSets[indexPath.row].category
            cell.view.layer.cornerRadius = 5
            cell.view.layer.masksToBounds = false
            cell.view.layer.shadowOffset = CGSize(width: 1, height: 3)
            cell.view.layer.shadowOpacity = 0.2
            cell.view.layer.shadowRadius = 3
            
            return cell
        }else{
            return cell
        }
    }
    
}