//
//  DetailAllViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/20.
//

import UIKit

class DetailAllViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var profileArray = [String]()
    var paymentArray = [String]()
    var userNameArray = [String]()
    var dateArray = [String]()
    var categoryArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "detailCell")
        
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
       
        
        return cell
    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        // シェアのアクションを設定する
//        let shareAction = UIContextualAction(style: .normal  , title: "share") {
//            (ctxAction, view, completionHandler) in
//            print("シェアを実行する")
//            completionHandler(true)
//        }
//        // シェアボタンのデザインを設定する
//        let shareImage = UIImage(systemName: "square.and.arrow.up")?.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)
//        shareAction.image = shareImage
//        shareAction.backgroundColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1)
//
//        // 削除のアクションを設定する
//        let deleteAction = UIContextualAction(style: .destructive, title:"delete") {
//            (ctxAction, view, completionHandler) in
//            self.tableData.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            completionHandler(true)
//        }
//        // 削除ボタンのデザインを設定する
//        let trashImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.white , renderingMode: .alwaysTemplate)
//        deleteAction.image = trashImage
//        deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
//
//        // スワイプでの削除を無効化して設定する
//        let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction, shareAction])
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
