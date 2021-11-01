//
//  MonthDataViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit
import Charts


class MonthDataViewController: UIViewController,GoToVcDelegate,UIScrollViewDelegate,LoadOKDelegate {

    //追加
    var loadDBModel = LoadDBModel()
    var myEmail = String()
    var groupID = String()
    var year = String()
    var month = String()
    
    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    @IBOutlet weak var addPaymentButton: UIButton!
    @IBOutlet weak var configurationButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var userPaymentThisMonth: UILabel!
    @IBOutlet weak var groupPaymentOfThisMonth: UILabel!
    @IBOutlet weak var paymentAverageOfTithMonth: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var groupNameBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var configurationButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    var graphModel = GraphModel()
    var categorypay = [Int]()
    
    
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
        
    }
    //追加
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.dateComponents([.year,.month], from: Date())
        year = String(date.year!)
        month = String(date.month!)
        groupID = UserDefaults.standard.object(forKey: "groupID") as! String
        myEmail = UserDefaults.standard.object(forKey: "myEmail") as! String
        loadDBModel.loadOKDelegate = self
        loadDBModel.loadGroupName(email: myEmail, groupID: groupID)
    }
    
    //追加
    //groupName取得完了
    func loadGroupName_OK(groupName: String) {
        groupNameLabel.text = groupName
        loadDBModel.loadCategoryGraphOfTithMonth(groupID: groupID, year: year, month: month)
    }
    
    //グラフに反映するカテゴリ別合計金額取得完了
    func loadCategoryGraphOfTithMonth_OK(categoryAmountArray: [Int]) {
        categorypay = categoryAmountArray
        graphModel.setPieCht(piecht: pieChartView, categorypay: categorypay)
        loadDBModel.loadNumberOfPeople(groupID: groupID)
    }

    //グループ人数取得完了
    func loadNumberOfPeople_OK(numberOfPeople: Int) {
        loadDBModel.loadMonthTotalAmount(groupID: groupID, year: year, month: month, myEmail: myEmail, numberOfPeople: numberOfPeople)
    }

    //ログインユーザー決済額、グループの合計出資額、1人当たりの出資額を取得完了
    func loadMonthTotalAmount_OK(myPaymentOfMonth: Int, groupPaymentOfMonth: Int, paymentAverageOfMonth: Int) {
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
