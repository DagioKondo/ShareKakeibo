//
//  LoadDBModel.swift
//  Kakeibo
//
//  Created by 都甲裕希 on 2021/10/24.
//

import Foundation
import Firebase
import FirebaseFirestore

@objc protocol LoadOKDelegate {
    @objc optional func loadUserInfo_OK(userName:String,profileImage:String,email:String,password:String)
    @objc optional func loadUserSearch_OK()
    @objc optional func loadGroupInfo_OK()
    @objc optional func loadGroupName_OK(groupName:String,groupImage:String)
    @objc optional func loadSettlementNotification_OK()
    @objc optional func loadSettlementDay_OK(settlementDay:String)
    @objc optional func loadGroupMember_OK(profileImageDic:Dictionary<String,String>,userNameDic:Dictionary<String,String>)
    @objc optional func loadMonthDetails_OK()
    @objc optional func loadCategoryGraphOfTithMonth_OK(categoryPayArray:[Int])
    @objc optional func loadMonthlyTransition_OK(countArray:[Int])
    @objc optional func loadMonthTotalAmount_OK(myPaymentOfMonth: Int, groupPaymentOfMonth: Int, paymentAverageOfMonth: Int)
    @objc optional func loadNumberOfPeople_OK(numberOfPeople:Int)
    @objc optional func loadMytotalAmount_OK(myTotalPaymentAmount:Int)
    @objc optional func loadGroupMemberSettlement_OK(profileImageArray:[String],userNameArray:[String],settlementArray:[Bool],howMuchArray:[Int],userPayment:Int)
}

class LoadDBModel{
    
    var loadOKDelegate:LoadOKDelegate?
    var db = Firestore.firestore()
    var userSearchSets:[UserSearchSets] = []
    var joinGroupTrueSets:[JoinGroupTrueSets] = []
    var joinGroupFalseSets:[JoinGroupFalseSets] = []
    var notificationSets:[NotificationSets] = []
    var monthMyDetailsSets:[MonthMyDetailsSets] = []
    var monthGroupDetailsSets:[MonthGroupDetailsSets] = []
    var january = 0
    var february = 0
    var march = 0
    var april = 0
    var may = 0
    var june = 0
    var july = 0
    var august = 0
    var september = 0
    var october = 0
    var november = 0
    var december = 0
    let dateFormatter = DateFormatter()
    var countArray = [Int]()
    var numberOfPeople = 0
    
    //userの情報を取得するメソッド
    func loadUserInfo(userID:String,activityIndicatorView:UIActivityIndicatorView){
        db.collection("userManagement").document(userID).addSnapshotListener { (snapShot, error) in
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            let data = snapShot?.data()
            if let userName = data!["userName"] as? String,let profileImage = data!["profileImage"] as? String,let email = data!["email"] as? String,let password = data!["password"] as? String{
                self.loadOKDelegate?.loadUserInfo_OK?(userName: userName, profileImage: profileImage, email: email, password: password)
            }
            activityIndicatorView.stopAnimating()
        }
    }
    
    //メールアドレスで検索するメソッド。メールアドレスと一致するユーザー情報を取得。
    func loadUserSearch(email:String,activityIndicatorView:UIActivityIndicatorView){
        db.collection("userManagement").whereField("email", isEqualTo: email).addSnapshotListener { (snapShot, error) in
            self.userSearchSets = []
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let userName = data["userName"] as! String
                    let profileImage = data["profileImage"] as! String
                    let userID = data["userID"] as! String
                    let newData = UserSearchSets(userName: userName, profileImage: profileImage, userID: userID)
                    self.userSearchSets.append(newData)
                }
            }
            self.loadOKDelegate?.loadUserSearch_OK?()
        }
    }
    
    //ルームの参加不参加を取得するメソッド
    func loadGroupInfo(userID:String,activityIndicatorView:UIActivityIndicatorView){
        print(userID)
        db.collection("groupManagement").whereField("joinGroupDic", in: [[userID:true],[userID:false]]).addSnapshotListener { (snapShot, error) in
            self.joinGroupTrueSets = []
            self.joinGroupFalseSets = []
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let joinGroupDic = data["joinGroupDic"] as? Dictionary<String,Bool>
                    let groupName = data["groupName"] as? String
                    let groupImage = data["groupImage"] as? String
                    let groupID = data["groupID"] as? String
                    switch joinGroupDic![userID] {
                    case true:   //←グループに参加している場合
                        let newTrue = JoinGroupTrueSets(groupName: groupName!,
                                                        groupImage: groupImage!, groupID: groupID!)
                        self.joinGroupTrueSets.append(newTrue)
                    case false:  //←グループに参加していない場合
                        let newFalse = JoinGroupFalseSets(groupName: groupName!, groupImage: groupImage!, groupID: groupID!)
                        self.joinGroupFalseSets.append(newFalse)
                    default: break
                    }
                }
            }
            self.loadOKDelegate?.loadGroupInfo_OK?()
        }
    }
    
    //今見ているグループ名、グループ画像を取得するロード。
    func loadGroupName(groupID:String,activityIndicatorView:UIActivityIndicatorView){
        db.collection("groupManagement").document(groupID).addSnapshotListener { (snapShot, error) in
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let data = snapShot?.data(){
                let groupName = data["groupName"] as! String
                let groupImage = data["groupImage"] as! String
                self.loadOKDelegate?.loadGroupName_OK?(groupName: groupName, groupImage: groupImage)
            }
        }
    }
    
    //決済日を取得し決済通知するロード
    func loadSettlementNotification(userID:String,day:String,activityIndicatorView:UIActivityIndicatorView){
        db.collection("groupManagement").whereField("joinGroupDic", isEqualTo: [userID:true]).addSnapshotListener { (snapShot, error) in
            self.notificationSets = []
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let settlementDay = data["settlementDay"] as! String
                    let groupName = data["groupName"] as! String
                    let groupID = data["groupID"] as! String
                    if settlementDay == day{
                        let newData = NotificationSets(groupName: groupName, groupID: groupID)
                        self.notificationSets.append(newData)
                    }
                }
            }
            self.loadOKDelegate?.loadSettlementNotification_OK?()
        }
    }
    
    //決済日を取得するロード
    func loadSettlementDay(groupID:String,activityIndicatorView:UIActivityIndicatorView){
        db.collection("groupManagement").document(groupID).getDocument { (snapShot, error) in
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let data = snapShot?.data(){
                let settlementDay = data["settlementDay"] as! String
                self.loadOKDelegate?.loadSettlementDay_OK?(settlementDay: settlementDay)
            }
            activityIndicatorView.stopAnimating()
        }
    }
    
    //グループに所属する人の名前とプロフィール画像を取得するロード
    func loadGroupMember(groupID:String){
        db.collection("groupManagement").document(groupID).getDocument { (snapShot, error) in
            if error != nil{
                return
            }
            if let data = snapShot?.data(){
                let profileImageDic = data["profileImageDic"] as! Dictionary<String,String>
                let userNameDic = data["userNameDic"] as! Dictionary<String,String>
                self.loadOKDelegate?.loadGroupMember_OK?(profileImageDic: profileImageDic, userNameDic: userNameDic)
            }
        }
    }
    
    //全体の明細のロード(月分)
    //自分の明細のロード(月分)
    func loadMonthDetails(groupID:String,startDate:Date,endDate:Date,userID:String?,activityIndicatorView:UIActivityIndicatorView){
        self.dateFormatter.dateFormat = "yyyy/MM/dd"
        self.dateFormatter.locale = Locale(identifier: "ja_JP")
        self.dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        if userID == nil{
            //全体の明細のロード(月分)
            db.collection(groupID).whereField("paymentDay", isGreaterThan: startDate).whereField("paymentDay", isLessThanOrEqualTo: endDate).order(by: "paymentDay").addSnapshotListener { (snapShot, error) in
                self.monthGroupDetailsSets = []
                if error != nil{
                    activityIndicatorView.stopAnimating()
                    return
                }
                if let snapShotDoc = snapShot?.documents{
                    for doc in snapShotDoc{
                        let data = doc.data()
                        let productName = data["productName"] as! String
                        let paymentAmount = data["paymentAmount"] as! Int
                        let date = data["paymentDay"] as! Date
                        let category = data["category"] as! String
                        let userID = data["userID"] as! String
                        let paymentDay = self.dateFormatter.string(from: date)
                        let groupNewData = MonthGroupDetailsSets(productName: productName, paymentAmount: paymentAmount, paymentDay: paymentDay, category: category, userID: userID)
                        self.monthGroupDetailsSets.append(groupNewData)
                    }
                }
                self.loadOKDelegate?.loadMonthDetails_OK?()
            }
        }else if userID != nil{
            //自分の明細のロード(月分)
            db.collection(groupID).whereField("userID", isEqualTo: userID!).whereField("paymentDay", isGreaterThan: startDate).whereField("paymentDay", isLessThanOrEqualTo: endDate).order(by: "paymentDay").addSnapshotListener { (snapShot, error) in
                self.monthMyDetailsSets = []
                if error != nil{
                    activityIndicatorView.stopAnimating()
                    return
                }
                if let snapShotDoc = snapShot?.documents{
                    for doc in snapShotDoc{
                        let data = doc.data()
                        let productName = data["productName"] as! String
                        let paymentAmount = data["paymentAmount"] as! Int
                        let date = data["paymentDay"] as! Date
                        let category = data["category"] as! String
                        let userID = data["userID"] as! String
                        let paymentDay = self.dateFormatter.string(from: date)
                        let myNewData = MonthMyDetailsSets(productName: productName, paymentAmount: paymentAmount, paymentDay: paymentDay, category: category, userID: userID)
                        self.monthMyDetailsSets.append(myNewData)
                    }
                }
                self.loadOKDelegate?.loadMonthDetails_OK?()
            }
        }
    }
    
    //カテゴリ別の合計金額金額
    func loadCategoryGraphOfTithMonth(groupID:String,startDate:Date,endDate:Date,activityIndicatorView:UIActivityIndicatorView){
        db.collection(groupID).whereField("paymentDay", isGreaterThan: startDate).whereField("paymentDay", isLessThanOrEqualTo: endDate).addSnapshotListener { (snapShot, error) in
            var categoryPayArray = [Int]()
            var foodCount = 0
            var waterCount = 0
            var electricityCount = 0
            var gasCount = 0
            var communicationCount = 0
            var rentCount = 0
            var othersCount = 0
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let category = data["category"] as! String
                    let paymentAmount = data["paymentAmount"] as! Int
                    switch category {
                    case "食費":
                        foodCount = foodCount + paymentAmount
                    case "水道代":
                        waterCount = waterCount + paymentAmount
                    case "電気代":
                        electricityCount = electricityCount + paymentAmount
                    case "ガス代":
                        gasCount = gasCount + paymentAmount
                    case "通信費":
                        communicationCount = communicationCount + paymentAmount
                    case "家賃":
                        rentCount = rentCount + paymentAmount
                    case "その他":
                        othersCount = othersCount + paymentAmount
                    default:
                        break
                    }
                }
                categoryPayArray = [foodCount,waterCount,electricityCount,gasCount,communicationCount,rentCount,othersCount]
            }
            self.loadOKDelegate?.loadCategoryGraphOfTithMonth_OK?(categoryPayArray: categoryPayArray)
        }
    }
    
    //1〜12月の全体の推移
    func loadMonthlyAllTransition(groupID:String,year:String,settlementDay:String,startDate:Date,endDate:Date,activityIndicatorView:UIActivityIndicatorView){
        db.collection(groupID).whereField("paymentDay", isGreaterThan: startDate).whereField("paymentDay", isLessThanOrEqualTo: endDate).addSnapshotListener { [self] (snapShot, error) in
            self.countArray = []
            self.dateFormatter.dateFormat = "yyyy年MM月dd日"
            self.dateFormatter.locale = Locale(identifier: "ja_JP")
            self.dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            let january = dateFormatter.date(from: "\(year)年1月\(settlementDay)日")
            let february = dateFormatter.date(from: "\(year)年2月\(settlementDay)日")
            let march = dateFormatter.date(from: "\(year)年3月\(settlementDay)日")
            let april = dateFormatter.date(from: "\(year)年4月\(settlementDay)日")
            let may = dateFormatter.date(from: "\(year)年5月\(settlementDay)日")
            let june = dateFormatter.date(from: "\(year)年6月\(settlementDay)日")
            let july = dateFormatter.date(from: "\(year)年7月\(settlementDay)日")
            let august = dateFormatter.date(from: "\(year)年8月\(settlementDay)日")
            let september = dateFormatter.date(from: "\(year)年9月\(settlementDay)日")
            let october = dateFormatter.date(from: "\(year)年10月\(settlementDay)日")
            let november = dateFormatter.date(from: "\(year)年11月\(settlementDay)日")
            let december = dateFormatter.date(from: "\(year)年12月\(settlementDay)日")
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let paymentAmount = data["paymentAmount"] as! Int
                    let paymentDay = data["paymentDay"] as! Date
                    if startDate < paymentDay && paymentDay >= january!{
                        self.january = self.january + paymentAmount
                    }else if january! < paymentDay && paymentDay >= february!{
                        self.february = self.february + paymentAmount
                    }else if february! < paymentDay && paymentDay >= march!{
                        self.march = self.march + paymentAmount
                    }else if march! < paymentDay && paymentDay >= april!{
                        self.april = self.april + paymentAmount
                    }else if april! < paymentDay && paymentDay >= may!{
                        self.may = self.may + paymentAmount
                    }else if may! < paymentDay && paymentDay >= june!{
                        self.june = self.june + paymentAmount
                    }else if june! < paymentDay && paymentDay >= july!{
                        self.july = self.july + paymentAmount
                    }else if july! < paymentDay && paymentDay >= august!{
                        self.august = self.august + paymentAmount
                    }else if august! < paymentDay && paymentDay >= september!{
                        self.september = self.september + paymentAmount
                    }else if september! < paymentDay && paymentDay >= october!{
                        self.october = self.october + paymentAmount
                    }else if october! < paymentDay && paymentDay >= november!{
                        self.november = self.november + paymentAmount
                    }else if november! < paymentDay && paymentDay >= december!{
                        self.december = self.december + paymentAmount
                    }
                }
            }
            self.countArray = [self.january,self.february,self.march,self.april,self.may,self.june,self.july,self.august,self.september,self.october,self.november,self.december]
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //1〜12月の項目ごとの光熱費の推移
    func loadMonthlyUtilityTransition(groupID:String,year:String,settlementDay:String,startDate:Date,endDate:Date,activityIndicatorView:UIActivityIndicatorView){
        db.collection(groupID).whereField("paymentDay", isGreaterThan: startDate).whereField("paymentDay", isLessThanOrEqualTo: endDate).whereField("category", isEqualTo: "水道代").whereField("category", isEqualTo: "電気代").whereField("category", isEqualTo: "ガス代").addSnapshotListener { [self] (snapShot, error) in
            self.countArray = []
            self.dateFormatter.dateFormat = "yyyy年MM月dd日"
            self.dateFormatter.locale = Locale(identifier: "ja_JP")
            self.dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            let january = dateFormatter.date(from: "\(year)年1月\(settlementDay)日")
            let february = dateFormatter.date(from: "\(year)年2月\(settlementDay)日")
            let march = dateFormatter.date(from: "\(year)年3月\(settlementDay)日")
            let april = dateFormatter.date(from: "\(year)年4月\(settlementDay)日")
            let may = dateFormatter.date(from: "\(year)年5月\(settlementDay)日")
            let june = dateFormatter.date(from: "\(year)年6月\(settlementDay)日")
            let july = dateFormatter.date(from: "\(year)年7月\(settlementDay)日")
            let august = dateFormatter.date(from: "\(year)年8月\(settlementDay)日")
            let september = dateFormatter.date(from: "\(year)年9月\(settlementDay)日")
            let october = dateFormatter.date(from: "\(year)年10月\(settlementDay)日")
            let november = dateFormatter.date(from: "\(year)年11月\(settlementDay)日")
            let december = dateFormatter.date(from: "\(year)年12月\(settlementDay)日")
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let paymentAmount = data["paymentAmount"] as! Int
                    let paymentDay = data["paymentDay"] as! Date
                    if startDate < paymentDay && paymentDay >= january!{
                        self.january = self.january + paymentAmount
                    }else if january! < paymentDay && paymentDay >= february!{
                        self.february = self.february + paymentAmount
                    }else if february! < paymentDay && paymentDay >= march!{
                        self.march = self.march + paymentAmount
                    }else if march! < paymentDay && paymentDay >= april!{
                        self.april = self.april + paymentAmount
                    }else if april! < paymentDay && paymentDay >= may!{
                        self.may = self.may + paymentAmount
                    }else if may! < paymentDay && paymentDay >= june!{
                        self.june = self.june + paymentAmount
                    }else if june! < paymentDay && paymentDay >= july!{
                        self.july = self.july + paymentAmount
                    }else if july! < paymentDay && paymentDay >= august!{
                        self.august = self.august + paymentAmount
                    }else if august! < paymentDay && paymentDay >= september!{
                        self.september = self.september + paymentAmount
                    }else if september! < paymentDay && paymentDay >= october!{
                        self.october = self.october + paymentAmount
                    }else if october! < paymentDay && paymentDay >= november!{
                        self.november = self.november + paymentAmount
                    }else if november! < paymentDay && paymentDay >= december!{
                        self.december = self.december + paymentAmount
                    }
                }
            }
            self.countArray = [self.january,self.february,self.march,self.april,self.may,self.june,self.july,self.august,self.september,self.october,self.november,self.december]
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //1〜12月の項目ごとの食費の推移
    func loadMonthlyFoodTransition(groupID:String,year:String,settlementDay:String,startDate:Date,endDate:Date,activityIndicatorView:UIActivityIndicatorView){
        db.collection(groupID).whereField("paymentDay", isGreaterThan: startDate).whereField("paymentDay", isLessThanOrEqualTo: endDate).whereField("category", isEqualTo: "食費").addSnapshotListener { [self] (snapShot, error) in
            self.countArray = []
            self.dateFormatter.dateFormat = "yyyy年MM月dd日"
            self.dateFormatter.locale = Locale(identifier: "ja_JP")
            self.dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            let january = dateFormatter.date(from: "\(year)年1月\(settlementDay)日")
            let february = dateFormatter.date(from: "\(year)年2月\(settlementDay)日")
            let march = dateFormatter.date(from: "\(year)年3月\(settlementDay)日")
            let april = dateFormatter.date(from: "\(year)年4月\(settlementDay)日")
            let may = dateFormatter.date(from: "\(year)年5月\(settlementDay)日")
            let june = dateFormatter.date(from: "\(year)年6月\(settlementDay)日")
            let july = dateFormatter.date(from: "\(year)年7月\(settlementDay)日")
            let august = dateFormatter.date(from: "\(year)年8月\(settlementDay)日")
            let september = dateFormatter.date(from: "\(year)年9月\(settlementDay)日")
            let october = dateFormatter.date(from: "\(year)年10月\(settlementDay)日")
            let november = dateFormatter.date(from: "\(year)年11月\(settlementDay)日")
            let december = dateFormatter.date(from: "\(year)年12月\(settlementDay)日")
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let paymentAmount = data["paymentAmount"] as! Int
                    let paymentDay = data["paymentDay"] as! Date
                    if startDate < paymentDay && paymentDay >= january!{
                        self.january = self.january + paymentAmount
                    }else if january! < paymentDay && paymentDay >= february!{
                        self.february = self.february + paymentAmount
                    }else if february! < paymentDay && paymentDay >= march!{
                        self.march = self.march + paymentAmount
                    }else if march! < paymentDay && paymentDay >= april!{
                        self.april = self.april + paymentAmount
                    }else if april! < paymentDay && paymentDay >= may!{
                        self.may = self.may + paymentAmount
                    }else if may! < paymentDay && paymentDay >= june!{
                        self.june = self.june + paymentAmount
                    }else if june! < paymentDay && paymentDay >= july!{
                        self.july = self.july + paymentAmount
                    }else if july! < paymentDay && paymentDay >= august!{
                        self.august = self.august + paymentAmount
                    }else if august! < paymentDay && paymentDay >= september!{
                        self.september = self.september + paymentAmount
                    }else if september! < paymentDay && paymentDay >= october!{
                        self.october = self.october + paymentAmount
                    }else if october! < paymentDay && paymentDay >= november!{
                        self.november = self.november + paymentAmount
                    }else if november! < paymentDay && paymentDay >= december!{
                        self.december = self.december + paymentAmount
                    }
                }
            }
            self.countArray = [self.january,self.february,self.march,self.april,self.may,self.june,self.july,self.august,self.september,self.october,self.november,self.december]
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //1〜12月の項目ごとのその他の推移
    func loadMonthlyOthersTransition(groupID:String,year:String,settlementDay:String,startDate:Date,endDate:Date,activityIndicatorView:UIActivityIndicatorView){
        db.collection(groupID).whereField("paymentDay", isGreaterThan: startDate).whereField("paymentDay", isLessThanOrEqualTo: endDate).whereField("category", isEqualTo: "通信費").whereField("category", isEqualTo: "家賃").whereField("category", isEqualTo: "その他").addSnapshotListener { [self] (snapShot, error) in
            self.countArray = []
            self.dateFormatter.dateFormat = "yyyy年MM月dd日"
            self.dateFormatter.locale = Locale(identifier: "ja_JP")
            self.dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            let january = dateFormatter.date(from: "\(year)年1月\(settlementDay)日")
            let february = dateFormatter.date(from: "\(year)年2月\(settlementDay)日")
            let march = dateFormatter.date(from: "\(year)年3月\(settlementDay)日")
            let april = dateFormatter.date(from: "\(year)年4月\(settlementDay)日")
            let may = dateFormatter.date(from: "\(year)年5月\(settlementDay)日")
            let june = dateFormatter.date(from: "\(year)年6月\(settlementDay)日")
            let july = dateFormatter.date(from: "\(year)年7月\(settlementDay)日")
            let august = dateFormatter.date(from: "\(year)年8月\(settlementDay)日")
            let september = dateFormatter.date(from: "\(year)年9月\(settlementDay)日")
            let october = dateFormatter.date(from: "\(year)年10月\(settlementDay)日")
            let november = dateFormatter.date(from: "\(year)年11月\(settlementDay)日")
            let december = dateFormatter.date(from: "\(year)年12月\(settlementDay)日")
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let paymentAmount = data["paymentAmount"] as! Int
                    let paymentDay = data["paymentDay"] as! Date
                    if startDate < paymentDay && paymentDay >= january!{
                        self.january = self.january + paymentAmount
                    }else if january! < paymentDay && paymentDay >= february!{
                        self.february = self.february + paymentAmount
                    }else if february! < paymentDay && paymentDay >= march!{
                        self.march = self.march + paymentAmount
                    }else if march! < paymentDay && paymentDay >= april!{
                        self.april = self.april + paymentAmount
                    }else if april! < paymentDay && paymentDay >= may!{
                        self.may = self.may + paymentAmount
                    }else if may! < paymentDay && paymentDay >= june!{
                        self.june = self.june + paymentAmount
                    }else if june! < paymentDay && paymentDay >= july!{
                        self.july = self.july + paymentAmount
                    }else if july! < paymentDay && paymentDay >= august!{
                        self.august = self.august + paymentAmount
                    }else if august! < paymentDay && paymentDay >= september!{
                        self.september = self.september + paymentAmount
                    }else if september! < paymentDay && paymentDay >= october!{
                        self.october = self.october + paymentAmount
                    }else if october! < paymentDay && paymentDay >= november!{
                        self.november = self.november + paymentAmount
                    }else if november! < paymentDay && paymentDay >= december!{
                        self.december = self.december + paymentAmount
                    }
                }
            }
            self.countArray = [self.january,self.february,self.march,self.april,self.may,self.june,self.july,self.august,self.september,self.october,self.november,self.december]
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //グループ人数を取得するロード
    func loadNumberOfPeople(groupID:String,activityIndicatorView:UIActivityIndicatorView){
        db.collection("groupManagement").document(groupID).addSnapshotListener { (snapShot, error) in
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let data = snapShot?.data(){
                let userNameDic = data["userNameDic"] as! Dictionary<String,String>
                self.numberOfPeople = userNameDic.count
            }
            self.loadOKDelegate?.loadNumberOfPeople_OK?(numberOfPeople: self.numberOfPeople)
        }
    }
    
    //(自分の支払い合計金額)と(全体の合計金額のロード)と(1人当たりの出資額)のロード(月分)
    func loadMonthTotalAmount(groupID:String,userID:String,startDate:Date,endDate:Date,numberOfPeople:Int,activityIndicatorView:UIActivityIndicatorView){
        db.collection(groupID).whereField("paymentDay", isGreaterThan: startDate).whereField("paymentDay", isLessThanOrEqualTo: endDate).addSnapshotListener { (snapShot, error) in
            var totalMyAmount = 0
            var groupPaymentOfMonth = 0
            var myPaymentOfMonth = 0
            var paymentAverageOfMonth = 0
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let paymentAmount = data["paymentAmount"] as! Int
                    let myUserID = data["userID"] as! String
                    if myUserID == userID{
                        totalMyAmount = totalMyAmount + paymentAmount
                    }else{
                        groupPaymentOfMonth = groupPaymentOfMonth + paymentAmount
                    }
                }
                //グループの合計金額
                groupPaymentOfMonth = groupPaymentOfMonth + totalMyAmount
                //1人当たりの合計金額
                paymentAverageOfMonth = groupPaymentOfMonth / numberOfPeople
                //自分の支払い合計金額
                myPaymentOfMonth = paymentAverageOfMonth - totalMyAmount
            }
            self.loadOKDelegate?.loadMonthTotalAmount_OK?(myPaymentOfMonth: myPaymentOfMonth, groupPaymentOfMonth: groupPaymentOfMonth, paymentAverageOfMonth: paymentAverageOfMonth)
        }
    }
    
    
    //今月自分が使った金額を取得するロード
    //月が変わったら、ここをロードして値を0にしなければならない
    func loadMytotalAmount(groupID:String,userID:String,activityIndicatorView:UIActivityIndicatorView){
        db.collection("groupManagement").document(groupID).getDocument { (snapShot, error) in
            var myTotalPaymentAmount = 0
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let data = snapShot?.data(){
                let myTotalPaymentAmountDic = data["myTotalPaymentAmount"] as! Dictionary<String,Int>
                myTotalPaymentAmount = myTotalPaymentAmountDic[userID]!
            }
            self.loadOKDelegate?.loadMytotalAmount_OK?(myTotalPaymentAmount: myTotalPaymentAmount)
        }
    }
    
    //グループの支払状況のロード
    //(userName)と(決済の可否)と(各メンバーのプロフィール画像)と(自分の決済額)と(各メンバーの決済額)を取得するロード
    func loadGroupMemberSettlement(groupID:String,userID:String,activityIndicatorView:UIActivityIndicatorView){
        db.collection("groupManagement").document(groupID).addSnapshotListener { (snapShot, error) in
            var profileImageArray = [String]()
            var userNameArray = [String]()
            var settlementArray = [Bool]()
            var howMuchArray = [Int]()
            var userPayment = Int()
            
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let data = snapShot?.data(){
                let profileImageDic = data["profileImageDic"] as! Dictionary<String,String>
                let userNameDic = data["userNameDic"] as! Dictionary<String,String>
                let settlementDic = data["settlementDic"] as! Dictionary<String,Bool>
                let myTotalPaymentAmountDic = data["myTotalPaymentAmount"] as! Dictionary<String,Int>
                //プロフィール画像、ユーザーネーム、決済可否
                profileImageArray = Array(profileImageDic.values)
                userNameArray = Array(userNameDic.values)
                settlementArray = Array(settlementDic.values)
                //合計金額
                let myTotalPaymentAmountArray = Array(myTotalPaymentAmountDic.values)
                let totalPaymentAmount = myTotalPaymentAmountArray.reduce(0,+)
                //人数
                self.numberOfPeople = userNameDic.count
                //1人当たりの支出額
                let perPerson = totalPaymentAmount / self.numberOfPeople
                //各メンバーの決済額の配列
                howMuchArray = myTotalPaymentAmountDic.map{($1 - perPerson) * -1}
                //自分の決済額
                userPayment = myTotalPaymentAmountDic[userID]!
                userPayment = perPerson - userPayment
            }
            self.loadOKDelegate?.loadGroupMemberSettlement_OK?(profileImageArray: profileImageArray, userNameArray: userNameArray, settlementArray: settlementArray, howMuchArray: howMuchArray, userPayment: userPayment)
        }
    }
    
}

