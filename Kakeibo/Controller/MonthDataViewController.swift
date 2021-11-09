//
//  MonthDataViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit
import Charts
import SDWebImage


class MonthDataViewController: UIViewController,GoToVcDelegate,UIScrollViewDelegate,LoadOKDelegate {

    @IBOutlet weak var addPaymentButton: UIButton!
    @IBOutlet weak var configurationButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var userPaymentThisMonth: UILabel!
    @IBOutlet weak var groupPaymentOfThisMonth: UILabel!
    @IBOutlet weak var paymentAverageOfTithMonth: UILabel!
    @IBOutlet weak var groupImageView: UIImageView!
    //追加
    @IBOutlet weak var thisMonthLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var groupNameBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var configurationButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    var graphModel = GraphModel()
    var loadDBModel = LoadDBModel()
    //追加
    var activityIndicatorView = UIActivityIndicatorView()
    //削除
    //var categorypay = [Int]()
    //変更
    var userID = String()
    
    var groupID = String()
    //追加
    let dateFormatter = DateFormatter()
    
    var year = String()
    var month = String()
    //追加
    var startDate = Date()
    var endDate = Date()
    //
    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPaymentButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        addPaymentButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        addPaymentButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addPaymentButton.layer.shadowOpacity = 0.5
        addPaymentButton.layer.shadowRadius = 1
        
        configurationButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        configurationButton.layer.shadowOpacity = 0.7
        configurationButton.layer.shadowRadius = 1

        groupNameLabel.layer.shadowOpacity = 0.7
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        blurView.alpha = 0
        
        pieChartView.noDataText = "グラフに表示するテキストがありません"
        pieChartView.noDataTextColor = .red
        
        //追加
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .large
        activityIndicatorView.color = .darkGray
        view.addSubview(activityIndicatorView)
        
//        scrollView.refreshControl = UIRefreshControl()
//        scrollView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.dateComponents([.year,.month], from: Date())
        year = String(date.year!)
        month = String(date.month!)
        //追加
//        thisMonthLabel.text = year + "年" + month + "月分"
        groupID = UserDefaults.standard.object(forKey: "groupID") as! String
        //変更
        userID = UserDefaults.standard.object(forKey: "userID") as! String
        loadDBModel.loadOKDelegate = self
        //変更
        loadDBModel.loadSettlementDay(groupID: groupID, activityIndicatorView: activityIndicatorView)
    }
    
    @objc func refresh() {
//        scrollView.refreshControl?.endRefreshing()
    }
    
    //追加
    func loadSettlementDay_OK(settlementDay: String) {
        activityIndicatorView.stopAnimating()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        startDate = dateFormatter.date(from: "\(year)年\(month)月\(settlementDay)日")!
        if month == "12"{
            endDate = dateFormatter.date(from: "\(String(Int(year)! + 1))年\("1")月\(settlementDay)日")!
            loadDBModel.loadGroupName(groupID: groupID, activityIndicatorView: activityIndicatorView)
        }else{
            endDate = dateFormatter.date(from: "\(year)年\(String(Int(month)! + 1))月\(settlementDay)日")!
            loadDBModel.loadGroupName(groupID: groupID, activityIndicatorView: activityIndicatorView)
        }
    }
    
    //変更
    //groupName,groupImage取得完了
    func loadGroup_OK(groupName: String, groupImage: String) {
        activityIndicatorView.stopAnimating()
        groupNameLabel.text = groupName
        groupImageView.sd_setImage(with: URL(string: groupImage), completed: nil)
        loadDBModel.loadCategoryGraphOfTithMonth(groupID: groupID, startDate: startDate, endDate: endDate, activityIndicatorView: activityIndicatorView)
    }
    
    //変更
    //グラフに反映するカテゴリ別合計金額取得完了
    func loadCategoryGraphOfTithMonth_OK(categoryPayArray: [Int]) {
        activityIndicatorView.stopAnimating()
        graphModel.setPieCht(piecht: pieChartView, categorypay: categoryPayArray)
        loadDBModel.loadNumberOfPeople(groupID: groupID, activityIndicatorView: activityIndicatorView)
    }

    //グループ人数取得完了
    func loadNumberOfPeople_OK(numberOfPeople: Int) {
        activityIndicatorView.stopAnimating()
        loadDBModel.loadMonthTotalAmount(groupID: groupID, userID: userID, startDate: startDate, endDate: endDate, numberOfPeople: numberOfPeople, activityIndicatorView: activityIndicatorView)
    }

    //ログインユーザー決済額、グループの合計出資額、1人当たりの出資額を取得完了
    func loadMonthTotalAmount_OK(myPaymentOfMonth: Int, groupPaymentOfMonth: Int, paymentAverageOfMonth: Int) {
        activityIndicatorView.stopAnimating()
        self.userPaymentThisMonth.text = String(myPaymentOfMonth) + "　円"
        self.groupPaymentOfThisMonth.text = String(groupPaymentOfMonth) + "　円"
        self.paymentAverageOfTithMonth.text = String(paymentAverageOfMonth) + "　円"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)

        headerViewHeightConstraint.constant = max(150 - scrollView.contentOffset.y, 85)
        groupNameBottomConstraint.constant = max(5, 32 - scrollView.contentOffset.y)
        configurationButtonBottomConstraint.constant = max(5, 26 - scrollView.contentOffset.y)
        blurView.alpha = (0.7 / 85) * scrollView.contentOffset.y
    }
    
    @objc func touchDown(_ sender:UIButton){
        buttonAnimatedModel.startAnimation(sender: sender)
        addPaymentButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        addPaymentButton.layer.shadowOpacity = 0
        addPaymentButton.layer.shadowRadius = 0
    }
    
    @objc func touchUpOutside(_ sender:UIButton){
        buttonAnimatedModel.endAnimation(sender: sender)
        addPaymentButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addPaymentButton.layer.shadowOpacity = 0.5
        addPaymentButton.layer.shadowRadius = 1
    }
    
    @IBAction func addPaymentButton(_ sender: Any) {
        buttonAnimatedModel.endAnimation(sender: sender as! UIButton)
        performSegue(withIdentifier: "paymentVC", sender: nil)
        addPaymentButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addPaymentButton.layer.shadowOpacity = 0.5
        addPaymentButton.layer.shadowRadius = 1
    }
    
    @IBAction func configurationButton(_ sender: Any) {
        let GroupDetailVC = storyboard?.instantiateViewController(identifier: "GroupDetailVC") as! GroupDetailViewController
        GroupDetailVC.goToVcDelegate = self
        present(GroupDetailVC, animated: true, completion: nil)
    }
    
    func goToVC(segueID: String) {
        performSegue(withIdentifier: segueID, sender: nil)
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
