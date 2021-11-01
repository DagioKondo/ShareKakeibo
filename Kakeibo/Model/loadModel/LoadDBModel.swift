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
    @objc optional func loadGroupInfo_OK()
    @objc optional func loadGroupName_OK(groupName:String)
    @objc optional func loadSettlementNotification_OK()
    @objc optional func loadMonthDetails_OK()
    @objc optional func loadCategoryGraphOfTithMonth_OK(categoryAmountArray:[Int])
    @objc optional func loadMonthlyTransition_OK(countArray:[Int])
    @objc optional func loadMonthTotalAmount_OK(myPaymentOfMonth: Int, groupPaymentOfMonth: Int, paymentAverageOfMonth: Int)
    @objc optional func loadNumberOfPeople_OK(numberOfPeople:Int)
    @objc optional func loadGroupMember_OK()
    @objc optional func loadGroupMemberSettlement_OK(profileImageArray:[String],userNameArray:[String],settlementArray:[Bool],howMuchArray:[Int],userPayment:Int)
    
}

class LoadDBModel{
    
    var loadOKDelegate:LoadOKDelegate?
    var db = Firestore.firestore()
    var joinGroupTrueSets:[JoinGroupTrueSets] = []
    var joinGroupFalseSets:[JoinGroupFalseSets] = []
    var notificationSets:[NotificationSets] = []
    var monthMyDetailsSets:[MonthMyDetailsSets] = []
    var monthGroupDetailsSets:[MonthGroupDetailsSets] = []
    var memberSets:[MemberSets] = []
    var categoryAmountArray = [Int]()
    var countArray = [Int]()
    var numberOfPeople = 0
    
    
    //userの名前とプロフィール画像の取得するメソッド
    //メールアドレスで検索するメソッド。メールアドレスと一致するユーザー情報を取得。
    func loadUserInfo(myEmail:String){
        db.collection("usersManagement").document(myEmail).addSnapshotListener { (snapShot, error) in
            if error != nil{
                return
            }
            let data = snapShot?.data()
            if let userName = data!["userName"] as? String,let profileImage = data!["profileImage"] as? String,let email = data!["email"] as? String,let password = data!["password"] as? String{
                self.loadOKDelegate?.loadUserInfo_OK?(userName: userName, profileImage: profileImage, email: email, password: password )
            }
        }
    }
    
    //ルームの参加不参加を取得するメソッド
    func loadGroupInfo(myEmail:String){
        db.collection(myEmail).addSnapshotListener { (snapShot, error) in
            self.joinGroupTrueSets = []
            self.joinGroupFalseSets = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let joinGroup = data["joinGroup"] as? Bool
                    let groupName = data["groupName"] as? String
                    let profileImage = data["profileImage"] as? String
                    let groupID = data["groupID"] as? String
                    let inviter = data["inviter"] as? String
                    switch joinGroup {
                    case true:   //←グループに参加している場合
                        let newTrue = JoinGroupTrueSets(groupName: groupName!, profileImage: profileImage!, groupID: groupID!)
                        self.joinGroupTrueSets.append(newTrue)
                    case false:  //←グループに参加していない場合
                        let newFalse = JoinGroupFalseSets(groupName: groupName!, groupID: groupID!, inviter: inviter!)
                        self.joinGroupFalseSets.append(newFalse)
                    default: break
                    }
                }
                print("参加の配列")
                print("\(self.joinGroupTrueSets)")
                print("不参加の配列")
                print("\(self.joinGroupFalseSets)")
            }
            self.loadOKDelegate?.loadGroupInfo_OK?()
        }
    }
    
    //グループ名を取得するロード
    func loadGroupName(email:String,groupID:String){
        db.collection(email).document(groupID).addSnapshotListener { (snapShot, error) in
            if error != nil{
                return
            }
            if let data = snapShot?.data(){
                let groupName = data["groupName"] as! String
                self.loadOKDelegate?.loadGroupName_OK?(groupName: groupName)
            }
        }
    }
    
    //決済日を取得し決済通知するロード
    func loadSettlementNotification(myEmail:String,day:Int){
        db.collection(myEmail).addSnapshotListener { (snapShot, error) in
            self.notificationSets = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let settlement = data["settlement"] as! Int
                    let groupName = data["groupName"] as! String
                    let groupID = data["groupID"] as! String
                    if settlement == Int(day){
                        let newData = NotificationSets(groupName: groupName, groupID: groupID)
                        self.notificationSets.append(newData)
                    }
                }
            }
            self.loadOKDelegate?.loadSettlementNotification_OK?()
        }
    }
    
    //全体の明細のロード(月分)
    //自分の明細のロード(月分)
    func loadMonthDetails(groupID:String,year:String,month:String,myEmail:String){
        db.collection(groupID).document("details").collection(year).document(month).addSnapshotListener { (snapShot, error) in
            self.monthMyDetailsSets = []
            self.monthGroupDetailsSets = []
            var count = 0
            if error != nil{
                return
            }
            if let data = snapShot?.data(){
                let profileImageArray = data["profileImageArray"] as! Array<String>
                let productNameArray = data["productNameArray"] as! Array<String>
                let paymentAmountArray = data["paymentAmountArray"] as! Array<Int>
                let userNameArray = data["userNameArray"] as! Array<String>
                let paymentDayArray = data["paymentDayArray"] as! Array<Int>
                let categoryArray = data["categoryArray"] as! Array<String>
                let emailArray = data["emailArray"] as! Array<String>
                for email in emailArray{
                    if email == myEmail{
                        let myNewData = MonthMyDetailsSets(profileImage: profileImageArray[count], paymentName: productNameArray[count], paymentAmount: paymentAmountArray[count], userName: userNameArray[count], paymentDay: paymentDayArray[count], category: categoryArray[count])
                        self.monthMyDetailsSets.append(myNewData)
                    }
                    count = count + 1
                }
                let groupNewData = MonthGroupDetailsSets(profileImageArray: profileImageArray, productNameArray: productNameArray, paymentAmountArray: paymentAmountArray, userNameArray: userNameArray, paymentDayArray: paymentDayArray, categoryArray: categoryArray)
                self.monthGroupDetailsSets.append(groupNewData)
            }
            self.loadOKDelegate?.loadMonthDetails_OK?()
        }
    }
    
    func loadMonthDetailsDelete(groupID:String,year:String,month:String,myEmail:String,ID:Int){
        db.collection(groupID).document("details").collection(year).document(month).addSnapshotListener { (snapShot, error) in
            self.monthMyDetailsSets = []
            var count = 0
            if error != nil{
                return
            }
            if let data = snapShot?.data(){
                let profileImageArray = data["profileImageArray"] as! Array<String>
                let productNameArray = data["productNameArray"] as! Array<String>
                let paymentAmountArray = data["paymentAmountArray"] as! Array<Int>
                let userNameArray = data["userNameArray"] as! Array<String>
                let paymentDayArray = data["paymentDayArray"] as! Array<Int>
                let categoryArray = data["categoryArray"] as! Array<String>
                let emailArray = data["emailArray"] as! Array<String>
                for email in emailArray{
                    if email == myEmail{
                        let myNewData = MonthMyDetailsSets(profileImage: profileImageArray[count], paymentName: productNameArray[count], paymentAmount: paymentAmountArray[count], userName: userNameArray[count], paymentDay: paymentDayArray[count], category: categoryArray[count])
                        self.monthMyDetailsSets.append(myNewData)
                    }
                    count = count + 1
                }
                self.monthMyDetailsSets.remove(at: ID)
                self.db.collection(groupID).document("details").collection(year).document(month).updateData(["productNameArray" : self.monthMyDetailsSets])
            }
            self.loadOKDelegate?.loadMonthDetails_OK?()
        }
    }
    
    //グラフに表示
    //カテゴリ別の合計金額金額
    func loadCategoryGraphOfTithMonth(groupID:String,year:String,month:String){
        db.collection(groupID).document("details").collection(year).document(month).addSnapshotListener { (snapShot, error) in
            self.categoryAmountArray = []
            var foodCount = 0
            var waterCount = 0
            var electricityCount = 0
            var gasCount = 0
            var communicationCount = 0
            var rentCount = 0
            var othersCount = 0
            var count = 0
            if error != nil{
                return
            }
            
            if let data = snapShot?.data(){
                let categoryArray = data["categoryArray"] as! Array<String>
                let paymentAmountArray = data["paymentAmountArray"] as! Array<Int>
                for category in categoryArray{
                    switch category {
                    case "食費":
                        foodCount = foodCount + paymentAmountArray[count]
                    case "水道代":
                        waterCount = waterCount + paymentAmountArray[count]
                    case "電気代":
                        electricityCount = electricityCount + paymentAmountArray[count]
                    case "ガス代":
                        gasCount = gasCount + paymentAmountArray[count]
                    case "通信費":
                        communicationCount = communicationCount + paymentAmountArray[count]
                    case "家賃":
                        rentCount = rentCount + paymentAmountArray[count]
                    case "その他":
                        othersCount = othersCount + paymentAmountArray[count]
                    default:
                        break
                    }
                    count = count + 1
                }
                self.categoryAmountArray = [foodCount,waterCount,electricityCount,gasCount,communicationCount,rentCount,othersCount]
            }
            self.loadOKDelegate?.loadCategoryGraphOfTithMonth_OK?(categoryAmountArray: self.categoryAmountArray)
        }
    }
    
    //1〜12月の全体の推移
    func loadMonthlyAllTransition(groupID:String,year:String){
        db.collection(groupID).document("details").collection(year).addSnapshotListener { (snapShot, error) in
            self.countArray = [0,0,0,0,0,0,0,0,0,0,0,0]
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let month = Int(doc.documentID)
                    let data = doc.data()
                    let paymentAmountArray = data["paymentAmountArray"] as! Array<Int>
                    let paymentAmount = paymentAmountArray.reduce(0,+)
                    self.countArray[month! - 1] = paymentAmount
                }
            }
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //1〜12月の項目ごとの光熱費の推移
    func loadMonthlyUtilityTransition(groupID:String,year:String){
        db.collection(groupID).document("details").collection(year).addSnapshotListener { (snapShot, error) in
            self.countArray = [0,0,0,0,0,0,0,0,0,0,0,0]
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    var utilityCount = 0
                    var count = 0
                    let month = Int(doc.documentID)
                    let data = doc.data()
                    let categoryArray = data["categoryArray"] as! Array<String>
                    let paymentAmountArray = data["paymentAmountArray"] as! Array<Int>
                    for category in categoryArray{
                        if (category == "水道代") || (category == "電気代") || (category == "ガス代"){
                            utilityCount = utilityCount + paymentAmountArray[count]
                        }
                        count = count + 1
                    }
                    self.countArray[month! - 1] = utilityCount
                }
            }
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //1〜12月の項目ごとの食費の推移
    func loadMonthlyEatTransition(groupID:String,year:String){
        db.collection(groupID).document("details").collection(year).addSnapshotListener { (snapShot, error) in
            self.countArray = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    var eatCount = 0
                    var count = 0
                    let month = Int(doc.documentID)
                    let data = doc.data()
                    let categoryArray = data["categoryArray"] as! Array<String>
                    let paymentAmountArray = data["paymentAmountArray"] as! Array<Int>
                    for category in categoryArray{
                        if category == "食費"{
                            eatCount = eatCount + paymentAmountArray[count]
                        }
                        count = count + 1
                    }
                    self.countArray[month! - 1] = eatCount
                }
            }
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //1〜12月の項目ごとのその他の推移
    func loadMonthlyOthersTransition(groupID:String,year:String){
        db.collection(groupID).document("details").collection(year).addSnapshotListener { (snapShot, error) in
            self.countArray = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    var othersCount = 0
                    var count = 0
                    let month = Int(doc.documentID)
                    let data = doc.data()
                    let categoryArray = data["categoryArray"] as! Array<String>
                    let paymentAmountArray = data["paymentAmountArray"] as! Array<Int>
                    for category in categoryArray{
                        if (category == "通信費") || (category == "家賃") || (category == "その他"){
                            othersCount = othersCount + paymentAmountArray[count]
                        }
                        count = count + 1
                    }
                    self.countArray[month! - 1] = othersCount
                }
            }
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //グループ人数を取得するロード
    func loadNumberOfPeople(groupID:String){
        db.collection(groupID).addSnapshotListener { (snapShot, error) in
            
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                self.numberOfPeople = snapShotDoc.count
            }
            self.loadOKDelegate?.loadNumberOfPeople_OK?(numberOfPeople: self.numberOfPeople)
        }
    }
    
    //(自分の支払い合計金額)と(全体の合計金額のロード)と(1人当たりの出資額)のロード(月分)
    func loadMonthTotalAmount(groupID:String,year:String,month:String,myEmail:String,numberOfPeople:Int){
        db.collection(groupID).document("details").collection(year).document(month).addSnapshotListener { (snapShot, error) in
            var count = 0
            var totalMyAmount = 0
            var groupPaymentOfMonth = 0
            var myPaymentOfMonth = 0
            var paymentAverageOfMonth = 0
            if error != nil{
                return
            }
            if let data = snapShot?.data(){
                let paymentAmountArray = data["paymentAmountArray"] as! Array<Int>
                let emailArray = data["emailArray"] as! Array<String>
                for email in emailArray{
                    if email == myEmail{
                        totalMyAmount = totalMyAmount + paymentAmountArray[count]    //←自分が使ったお金
                    }
                    count = count + 1
                }
                print("合計人数と自分が使った金額")
                print(numberOfPeople)
                print(totalMyAmount)
                
                //グループの合計金額
                groupPaymentOfMonth = paymentAmountArray.reduce(0,+)
                //1人当たりの合計金額
                paymentAverageOfMonth = groupPaymentOfMonth / numberOfPeople
                //自分の支払い合計金額
                myPaymentOfMonth = groupPaymentOfMonth - totalMyAmount
                
                print("自分とグループと1人当たりの合計金額")
                print(groupPaymentOfMonth)         //←全体が使った合計金額
                print(paymentAverageOfMonth)       //←1人当たりの合計金額
                print(myPaymentOfMonth)            //←自分の支払い合計金額
                self.loadOKDelegate?.loadMonthTotalAmount_OK?(myPaymentOfMonth: myPaymentOfMonth, groupPaymentOfMonth: groupPaymentOfMonth, paymentAverageOfMonth: paymentAverageOfMonth)
            }
        }
    }
    
    //グループに所属する人の名前と決済可否を取得するロード
    func loadGroupMember(groupID:String){
        db.collection(groupID).addSnapshotListener { (snapShot, error) in
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let userName = data["userName"] as? String,let settlement = data["settlement"] as? Bool,let email = data["email"] as? String,let profileImage = data["profileImage"] as? String{
                        let newData = MemberSets(userName: userName, settlement: settlement, email: email,profileImage: profileImage)
                        self.memberSets.append(newData)
                    }
                }
                self.loadOKDelegate?.loadGroupMember_OK?()
            }
        }
    }
    
    //グループの支払状況のロード
    //(userName)と(決済の可否)と(各メンバーの決済額)と(各メンバーのプロフィール画像)を取得するロード
    func loadGroupMemberSettlement(groupID:String,myEmail:String){
        db.collection(groupID).addSnapshotListener { (snapShot, error) in
            var profileImageArray = [String]()
            var userNameArray = [String]()
            var settlementArray = [Bool]()
            var paymentOfPersonArray = Dictionary<String,Int>()
            var howMuchArray = [Int]()
            var userPayment = Int()
            var totalPaymentAmount = 0
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                self.numberOfPeople = snapShotDoc.count
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let profileImage = data["profileImage"] as? String,let userName = data["userName"] as? String,let settlement = data["settlement"] as? Bool,let myTotalPaymentAmount = data["myTotalPaymentAmount"] as? Int,let email = data["email"] as? String{
                        profileImageArray.append(profileImage)
                        userNameArray.append(userName)
                        settlementArray.append(settlement)
                        //合計金額
                        totalPaymentAmount = totalPaymentAmount + myTotalPaymentAmount
                        //各メンバーの支払った合計金額の配列
                        paymentOfPersonArray.updateValue(myTotalPaymentAmount, forKey: email)
                    }
                }
                //自分の決済額
                userPayment = paymentOfPersonArray[myEmail]!
                //1人当たりの支出額
                let perPerson = totalPaymentAmount / self.numberOfPeople
                //各メンバーの決済額の配列
                howMuchArray = paymentOfPersonArray.map{($1 - perPerson) * -1}
            }
            self.loadOKDelegate?.loadGroupMemberSettlement_OK?(profileImageArray: profileImageArray, userNameArray: userNameArray, settlementArray: settlementArray, howMuchArray: howMuchArray, userPayment: userPayment)
        }
    }
}

