//
//  DetailAllViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/20.
//

import UIKit
import SDWebImage

class DetailAllViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,LoadOKDelegate {
    
    //追加
    var loadDBModel = LoadDBModel()
    var editDBModel = EditDBModel()
    var monthGroupDetailsSets = [MonthGroupDetailsSets]()
    var activityIndicatorView = UIActivityIndicatorView()
    var groupID = String()
    let dateFormatter = DateFormatter()
    var year = String()
    var month = String()
    var startDate = Date()
    var endDate = Date()
    
    var tableView = UITableView()
    //変更
    var profileImageDic = Dictionary<String,String>()
    //    var paymentArray = [String]()
    var userNameDic = Dictionary<String,String>()
    //    var dateArray = [String]()
    //    var categoryArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "detailCell")
        
        self.view.addSubview(tableView)
        
        //追加
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .large
        activityIndicatorView.color = .darkGray
        view.addSubview(activityIndicatorView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //追加
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.dateComponents([.year,.month], from: Date())
        year = String(date.year!)
        month = String(date.month!)
        groupID = UserDefaults.standard.object(forKey: "groupID") as! String
        loadDBModel.loadOKDelegate = self
        loadDBModel.loadSettlementDay(groupID: groupID, activityIndicatorView: activityIndicatorView)
    }
    
    //追加
    //決済日取得完了
    func loadSettlementDay_OK(settlementDay: String) {
        activityIndicatorView.stopAnimating()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        startDate = dateFormatter.date(from: "\(year)年\(month)月\(settlementDay)日")!
        if month == "12"{
            endDate = dateFormatter.date(from: "\(String(Int(year)! + 1))年\("1")月\(settlementDay)日")!
            loadDBModel.loadMonthDetails(groupID: groupID, startDate: startDate, endDate: endDate, userID: nil, activityIndicatorView: activityIndicatorView)
        }else{
            endDate = dateFormatter.date(from: "\(year)年\(String(Int(month)! + 1))月\(settlementDay)日")!
            loadDBModel.loadMonthDetails(groupID: groupID, startDate: startDate, endDate: endDate, userID: nil, activityIndicatorView: activityIndicatorView)
        }
    }
    
    //追加
    //全体の明細を取得完了
    func loadMonthDetails_OK() {
        activityIndicatorView.stopAnimating()
        monthGroupDetailsSets = loadDBModel.monthGroupDetailsSets
        loadDBModel.loadGroupMember(groupID: groupID)
    }
    
    //追加
    //グループに所属する人の名前とプロフィール画像を取得するロード
    func loadGroupMember_OK(profileImageDic: Dictionary<String, String>, userNameDic: Dictionary<String, String>) {
        activityIndicatorView.stopAnimating()
        self.profileImageDic = profileImageDic
        self.userNameDic = userNameDic
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
        
        //追加
        cell.profileImage.sd_setImage(with: URL(string: profileImageDic[monthGroupDetailsSets[indexPath.row].userID]!), completed: nil)
        cell.paymentLabel.text = String(monthGroupDetailsSets[indexPath.row].paymentAmount)
        cell.userNameLabel.text = userNameDic[monthGroupDetailsSets[indexPath.row].userID]
        cell.dateLabel.text = monthGroupDetailsSets[indexPath.row].paymentDay
        cell.category.text = monthGroupDetailsSets[indexPath.row].category
        
        return cell
    }
    
    //削除
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        // 削除のアクションを設定する
//        let deleteAction = UIContextualAction(style: .destructive, title:"delete") {
//            (ctxAction, view, completionHandler) in
//            self.userNameArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            completionHandler(true)
//
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
