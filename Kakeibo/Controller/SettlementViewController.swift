//
//  SettlementViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit
import ViewAnimator
import SDWebImage
import FirebaseFirestore


class SettlementViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,LoadOKDelegate{
    
    
    @IBOutlet weak var userPaymentOfLastMonth: UILabel!
    @IBOutlet weak var settlementCompletionButton: UIButton!
    @IBOutlet weak var checkDetailButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var loadDBModel = LoadDBModel()
    var db = Firestore.firestore()
    //追加
    var activityIndicatorView = UIActivityIndicatorView()
    
    var groupID = String()
    //変更
    var userID = String()
    
    var year = String()
    var month = String()
    var userNameArray = [String]()
    var profileImageArray = [String]()
    var settlementArray = [Bool]()
    var howMuchArray = [Int]()
    
    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        settlementCompletionButton.layer.cornerRadius = 5
        settlementCompletionButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        settlementCompletionButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        
        checkDetailButton.layer.cornerRadius = 5
        checkDetailButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        checkDetailButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        
        //追加
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .large
        activityIndicatorView.color = .darkGray
        view.addSubview(activityIndicatorView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let animation = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        UIView.animate(views: tableView.visibleCells, animations: animation, completion:nil)
        
        if let indexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        groupID = UserDefaults.standard.object(forKey: "groupID") as! String
        //変更
        userID = UserDefaults.standard.object(forKey: "userID") as! String
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.dateComponents([.year,.month], from: Date())
        year = String(date.year!)
        month = String(date.month!)
        loadDBModel.loadOKDelegate = self
        //変更
        loadDBModel.loadGroupMemberSettlement(groupID: groupID, userID: userID, activityIndicatorView: activityIndicatorView)
    }
    
    //変更
    //グループの支払い状況の取得完了
    func loadGroupMemberSettlement_OK(profileImageArray: [String], userNameArray: [String], settlementArray: [Bool], howMuchArray: [Int], userPayment: Int) {
        activityIndicatorView.stopAnimating()
        if userPayment < 0{
            userPaymentOfLastMonth.text = "あなたは" + String(userPayment) + "の受け取りがあります"
        }else{
            userPaymentOfLastMonth.text = "あなたは" + String(userPayment) + "の支払いがあります"
        }
        self.profileImageArray = profileImageArray
        self.userNameArray = userNameArray
        self.settlementArray = settlementArray
        self.howMuchArray = howMuchArray
        tableView.reloadData()
    }
    
    @objc func touchDown(_ sender:UIButton){
        buttonAnimatedModel.startAnimation(sender: sender)
    }
    
    @objc func touchUpOutside(_ sender:UIButton){
        buttonAnimatedModel.endAnimation(sender: sender)
    }
    
    @IBAction func settlementCompletionButton(_ sender: Any) {
        buttonAnimatedModel.endAnimation(sender: sender as! UIButton)

        //変更
        db.collection("groupManagement").document(groupID).setData(["settlementDic" : [userID:true]],merge: true)
    }
    
    @IBAction func checkDetailButton(_ sender: Any) {
        buttonAnimatedModel.endAnimation(sender: sender as! UIButton)
        performSegue(withIdentifier: "lastMonthDataVC", sender: nil)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let cellView = cell?.contentView.viewWithTag(1) as! UIView
        let profileImage = cell?.contentView.viewWithTag(2) as! UIImageView
        let userNameLabel = cell?.contentView.viewWithTag(3) as! UILabel
        let checkSettlementLabel = cell?.contentView.viewWithTag(4) as! UILabel
        let howMuchLabel = cell?.contentView.viewWithTag(5) as! UILabel
        
        profileImage.layer.cornerRadius = 30
        profileImage.sd_setImage(with: URL(string: profileImageArray[indexPath.row]), completed: nil)
        userNameLabel.text = userNameArray[indexPath.row]
        
        checkSettlementLabel.layer.cornerRadius = 5
        if settlementArray[indexPath.row] == true{
            checkSettlementLabel.text = "決済済み"
            checkSettlementLabel.backgroundColor = .systemGreen
        }else{
            checkSettlementLabel.text = "未決済"
            checkSettlementLabel.backgroundColor = .systemRed
        }
        howMuchLabel.text = String(howMuchArray[indexPath.row])
        cellView.layer.cornerRadius = 5
        cellView.layer.masksToBounds = false
        cellView.layer.cornerRadius = 5
        cellView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cellView.layer.shadowOpacity = 0.2
        cellView.layer.shadowRadius = 1
        
        return cell!
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
