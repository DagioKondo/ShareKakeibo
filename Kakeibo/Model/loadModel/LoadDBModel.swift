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
    @objc optional func loadGroupInfoDelete_OK()
    @objc optional func loadGroupName_OK(groupName:String,groupImage:String)
    @objc optional func loadSettlementNotification_OK()
    @objc optional func loadMonthDetails_OK()
    @objc optional func loadMonthDetailsDelete_OK()
    @objc optional func loadCategoryGraphOfTithMonth_OK(categoryAmountArray:[Int])
    @objc optional func loadMonthlyTransition_OK(countArray:[Int])
    @objc optional func loadMonthTotalAmount_OK(myPaymentOfMonth: Int, groupPaymentOfMonth: Int, paymentAverageOfMonth: Int)
    @objc optional func loadNumberOfPeople_OK(numberOfPeople:Int)
    @objc optional func loadMytotalAmount_OK(myTotalPaymentAmount:Int)
    @objc optional func loadGroupMember_OK()
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
    var memberSets:[MemberSets] = []
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
    var countArray = [Int]()
    var numberOfPeople = 0
    
    
    //userの情報を取得するメソッド
    func loadUserInfo(userID:String){
        db.collection("userManagement").document(userID).addSnapshotListener { (snapShot, error) in
            if error != nil{
                return
            }
            let data = snapShot?.data()
            if let userName = data!["userName"] as? String,let profileImage = data!["profileImage"] as? String,let email = data!["email"] as? String,let password = data!["password"] as? String{
                self.loadOKDelegate?.loadUserInfo_OK?(userName: userName, profileImage: profileImage, email: email, password: password )
            }
        }
    }
    
    //メールアドレスで検索するメソッド。メールアドレスと一致するユーザー情報を取得。
    func loadUserSearch(email:String){
        db.collection("userManagement").whereField("email", isEqualTo: email).addSnapshotListener { (snapShot, error) in
            self.userSearchSets = []
            if error != nil{
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
    func loadGroupInfo(userID:String){
        db.collection("groupManagement").whereField("joinGroup", in: [[userID:true],[userID:false]]).addSnapshotListener { (snapShot, error) in
            self.joinGroupTrueSets = []
            self.joinGroupFalseSets = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let joinGroup = data["joinGroup"] as? Dictionary<String,Bool>
                    let groupName = data["groupName"] as? String
                    let groupImage = data["groupImage"] as? String
                    let groupID = data["groupID"] as? String
                    switch joinGroup![userID] {
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
    
    //招待を受けているグループで拒否ボタンを押したときのロード
    func loadGroupInfoDelete(groupID:String,userID:String){
        db.collection("groupManagement").document(groupID).getDocument { (snapShot, error) in
            if error != nil{
                return
            }
            if let data = snapShot?.data(){
                var joinGroup = data["joinGroup"] as! Dictionary<String,Bool>
                joinGroup.removeValue(forKey: userID)
                self.db.collection("groupManagement").document(groupID).updateData(["joinGroup" : joinGroup])
                self.loadOKDelegate?.loadGroupInfoDelete_OK?()
            }
        }
    }
    
    //今見ているグループ名、グループ画像を取得するロード。
    func loadGroupName(groupID:String){
        db.collection("groupManagement").document(groupID).addSnapshotListener { (snapShot, error) in
            if error != nil{
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
    func loadSettlementNotification(userID:String,day:String){
        db.collection("groupManagement").whereField("joinGroup", isEqualTo: [userID:true]).addSnapshotListener { (snapShot, error) in
            self.notificationSets = []
            if error != nil{
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
    
    //全体の明細のロード(月分)
    //自分の明細のロード(月分)
    func loadMonthDetails(groupID:String,year:String,month:String,userID:String?){
        if userID == nil{
            //全体の明細のロード(月分)
            db.collection(groupID).document("details").collection(year).whereField("paymentMonth", isEqualTo: month).order(by: "paymentDay").addSnapshotListener { (snapShot, error) in
                self.monthGroupDetailsSets = []
                if error != nil{
                    return
                }
                if let snapShotDoc = snapShot?.documents{
                    for doc in snapShotDoc{
                        let data = doc.data()
                        let profileImage = data["profileImage"] as! String
                        let productName = data["productName"] as! String
                        let paymentAmount = data["paymentAmount"] as! Int
                        let userName = data["userName"] as! String
                        let paymentDay = data["paymentDay"] as! String
                        let category = data["category"] as! String
                        let groupNewData = MonthGroupDetailsSets(profileImage: profileImage, productName: productName, paymentAmount: paymentAmount, userName: userName, paymentDay: paymentDay, category: category)
                        self.monthGroupDetailsSets.append(groupNewData)
                    }
                }
                self.loadOKDelegate?.loadMonthDetails_OK?()
            }
        }else if userID != nil{
            //自分の明細のロード(月分)
            db.collection(groupID).document("details").collection(year).whereField("userID", isEqualTo: userID!).whereField("paymentMonth", isEqualTo: month).order(by: "paymentDay").addSnapshotListener { (snapShot, error) in
                self.monthMyDetailsSets = []
                if error != nil{
                    return
                }
                if let snapShotDoc = snapShot?.documents{
                    for doc in snapShotDoc{
                        let data = doc.data()
                        let profileImage = data["profileImage"] as! String
                        let productName = data["productName"] as! String
                        let paymentAmount = data["paymentAmount"] as! Int
                        let userName = data["userName"] as! String
                        let paymentDay = data["paymentDay"] as! String
                        let category = data["category"] as! String
                        let myNewData = MonthMyDetailsSets(profileImage: profileImage, productName: productName, paymentAmount: paymentAmount, userName: userName, paymentDay: paymentDay, category: category)
                        self.monthMyDetailsSets.append(myNewData)
                    }
                }
                self.loadOKDelegate?.loadMonthDetails_OK?()
            }
        }
    }
    
    //自分の明細を削除したときにロード
    func loadMonthDetailsDelete(groupID:String,year:String,month:String,userID:String,index:Int){
        db.collection(groupID).document("details").collection(year).whereField("userID", isEqualTo: userID).whereField("paymentMonth", isEqualTo: month).order(by: "paymentDay").getDocuments { (snapShot, error) in
            self.monthMyDetailsSets = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                var count = 0
                for doc in snapShotDoc{
                    let data = doc.data()
                    let profileImage = data["profileImage"] as! String
                    let productName = data["productName"] as! String
                    let paymentAmount = data["paymentAmount"] as! Int
                    let userName = data["userName"] as! String
                    let paymentDay = data["paymentDay"] as! String
                    let category = data["category"] as! String
                    if count == index{
                        self.db.collection(groupID).document("details").collection(year).document(doc.documentID).delete()
                    }else{
                        let myNewData = MonthMyDetailsSets(profileImage: profileImage, productName: productName, paymentAmount: paymentAmount, userName: userName, paymentDay: paymentDay, category: category)
                        self.monthMyDetailsSets.append(myNewData)
                    }
                    count = count + 1
                }
            }
            self.loadOKDelegate?.loadMonthDetailsDelete_OK?()
        }
    }
    
    
    //カテゴリ別の合計金額金額
    func loadCategoryGraphOfTithMonth(groupID:String,year:String,month:String){
        db.collection(groupID).document("details").collection(year).whereField("paymentMonth", isEqualTo: month).addSnapshotListener { (snapShot, error) in
            var categoryAmountArray = [Int]()
            var foodCount = 0
            var waterCount = 0
            var electricityCount = 0
            var gasCount = 0
            var communicationCount = 0
            var rentCount = 0
            var othersCount = 0
            if error != nil{
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
                categoryAmountArray = [foodCount,waterCount,electricityCount,gasCount,communicationCount,rentCount,othersCount]
            }
            self.loadOKDelegate?.loadCategoryGraphOfTithMonth_OK?(categoryAmountArray: categoryAmountArray)
        }
    }
    
    //1〜12月の全体の推移
    func loadMonthlyAllTransition(groupID:String,year:String){
        db.collection(groupID).document("details").collection(year).addSnapshotListener { (snapShot, error) in
            self.countArray = []
            
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let paymentAmount = data["paymentAmount"] as! Int
                    let paymentMonth = data["paymentMonth"] as! String
                    switch paymentMonth {
                    case "1":
                        self.january = self.january + paymentAmount
                    case "2":
                        self.february = self.february + paymentAmount
                    case "3":
                        self.march = self.march + paymentAmount
                    case "4":
                        self.april = self.april + paymentAmount
                    case "5":
                        self.may = self.may + paymentAmount
                    case "6":
                        self.june = self.june + paymentAmount
                    case "7":
                        self.july = self.july + paymentAmount
                    case "8":
                        self.august = self.august + paymentAmount
                    case "9":
                        self.september = self.september + paymentAmount
                    case "10":
                        self.october = self.october + paymentAmount
                    case "11":
                        self.november = self.november + paymentAmount
                    case "12":
                        self.december = self.december + paymentAmount
                    default:
                        break
                    }
                }
            }
            self.countArray = [self.january,self.february,self.march,self.april,self.may,self.june,self.july,self.august,self.september,self.october,self.november,self.december]
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //1〜12月の項目ごとの光熱費の推移
    func loadMonthlyUtilityTransition(groupID:String,year:String){
        db.collection(groupID).document("details").collection(year).whereField("category", isEqualTo: "水道代").whereField("category", isEqualTo: "電気代").whereField("category", isEqualTo: "ガス代").addSnapshotListener { (snapShot, error) in
            self.countArray = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let paymentAmount = data["paymentAmount"] as! Int
                    let paymentMonth = data["paymentMonth"] as! String
                    switch paymentMonth {
                    case "1":
                        self.january = self.january + paymentAmount
                    case "2":
                        self.february = self.february + paymentAmount
                    case "3":
                        self.march = self.march + paymentAmount
                    case "4":
                        self.april = self.april + paymentAmount
                    case "5":
                        self.may = self.may + paymentAmount
                    case "6":
                        self.june = self.june + paymentAmount
                    case "7":
                        self.july = self.july + paymentAmount
                    case "8":
                        self.august = self.august + paymentAmount
                    case "9":
                        self.september = self.september + paymentAmount
                    case "10":
                        self.october = self.october + paymentAmount
                    case "11":
                        self.november = self.november + paymentAmount
                    case "12":
                        self.december = self.december + paymentAmount
                    default:
                        break
                    }
                }
            }
            self.countArray = [self.january,self.february,self.march,self.april,self.may,self.june,self.july,self.august,self.september,self.october,self.november,self.december]
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //1〜12月の項目ごとの食費の推移
    func loadMonthlyEatTransition(groupID:String,year:String){
        db.collection(groupID).document("details").collection(year).whereField("category", isEqualTo: "食費").addSnapshotListener { (snapShot, error) in
            self.countArray = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let paymentAmount = data["paymentAmount"] as! Int
                    let paymentMonth = data["paymentMonth"] as! String
                    switch paymentMonth {
                    case "1":
                        self.january = self.january + paymentAmount
                    case "2":
                        self.february = self.february + paymentAmount
                    case "3":
                        self.march = self.march + paymentAmount
                    case "4":
                        self.april = self.april + paymentAmount
                    case "5":
                        self.may = self.may + paymentAmount
                    case "6":
                        self.june = self.june + paymentAmount
                    case "7":
                        self.july = self.july + paymentAmount
                    case "8":
                        self.august = self.august + paymentAmount
                    case "9":
                        self.september = self.september + paymentAmount
                    case "10":
                        self.october = self.october + paymentAmount
                    case "11":
                        self.november = self.november + paymentAmount
                    case "12":
                        self.december = self.december + paymentAmount
                    default:
                        break
                    }
                }
            }
            self.countArray = [self.january,self.february,self.march,self.april,self.may,self.june,self.july,self.august,self.september,self.october,self.november,self.december]
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //1〜12月の項目ごとのその他の推移
    func loadMonthlyOthersTransition(groupID:String,year:String){
        db.collection(groupID).document("details").collection(year).whereField("category", isEqualTo: "通信費").whereField("category", isEqualTo: "家賃").whereField("category", isEqualTo: "その他").addSnapshotListener { (snapShot, error) in
            self.countArray = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let paymentAmount = data["paymentAmount"] as! Int
                    let paymentMonth = data["paymentMonth"] as! String
                    switch paymentMonth {
                    case "1":
                        self.january = self.january + paymentAmount
                    case "2":
                        self.february = self.february + paymentAmount
                    case "3":
                        self.march = self.march + paymentAmount
                    case "4":
                        self.april = self.april + paymentAmount
                    case "5":
                        self.may = self.may + paymentAmount
                    case "6":
                        self.june = self.june + paymentAmount
                    case "7":
                        self.july = self.july + paymentAmount
                    case "8":
                        self.august = self.august + paymentAmount
                    case "9":
                        self.september = self.september + paymentAmount
                    case "10":
                        self.october = self.october + paymentAmount
                    case "11":
                        self.november = self.november + paymentAmount
                    case "12":
                        self.december = self.december + paymentAmount
                    default:
                        break
                    }
                }
            }
            self.countArray = [self.january,self.february,self.march,self.april,self.may,self.june,self.july,self.august,self.september,self.october,self.november,self.december]
            self.loadOKDelegate?.loadMonthlyTransition_OK?(countArray: self.countArray)
        }
    }
    
    //グループ人数を取得するロード
    func loadNumberOfPeople(groupID:String){
        db.collection(groupID).whereField("userName", isEqualTo: true).addSnapshotListener { (snapShot, error) in
            
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                self.numberOfPeople = snapShotDoc.count
            }
            self.loadOKDelegate?.loadNumberOfPeople_OK?(numberOfPeople: self.numberOfPeople)
        }
    }
    
    //今月自分が使った金額を取得するロード
    func loadMytotalAmount(groupID:String,userID:String){
        db.collection(groupID).document(userID).getDocument { (snapShot, error) in
            var myTotalPaymentAmount = 0
            if error != nil{
                return
            }
            if let data = snapShot?.data(){
                myTotalPaymentAmount = data["myTotalPaymentAmount"] as! Int
            }
            self.loadOKDelegate?.loadMytotalAmount_OK?(myTotalPaymentAmount: myTotalPaymentAmount)
        }
    }
    
    //(自分の支払い合計金額)と(全体の合計金額のロード)と(1人当たりの出資額)のロード(月分)
    func loadMonthTotalAmount(groupID:String,year:String,month:String,userID:String,numberOfPeople:Int){
        db.collection(groupID).document("details").collection(year).whereField("paymentMonth", isEqualTo: month).addSnapshotListener { (snapShot, error) in
            var totalMyAmount = 0
            var groupPaymentOfMonth = 0
            var myPaymentOfMonth = 0
            var paymentAverageOfMonth = 0
            if error != nil{
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
    
    //グループに所属する人の名前と決済可否を取得するロード
    func loadGroupMember(groupID:String){
        db.collection(groupID).addSnapshotListener { (snapShot, error) in
            self.memberSets = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let userName = data["userName"] as? String,let settlement = data["settlement"] as? Bool,let userID = data["userID"] as? String{
                        let newData = MemberSets(userName: userName, settlement: settlement, userID: userID)
                        self.memberSets.append(newData)
                    }
                }
                self.loadOKDelegate?.loadGroupMember_OK?()
            }
        }
    }
    
    //グループの支払状況のロード
    //(userName)と(決済の可否)と(各メンバーの決済額)と(各メンバーのプロフィール画像)を取得するロード
    func loadGroupMemberSettlement(groupID:String,userID:String){
        db.collection(groupID).addSnapshotListener { (snapShot, error) in
            var profileImageArray = [String]()
            var userNameArray = [String]()
            var settlementArray = [Bool]()
            var paymentOfPersonArray = Dictionary<String,Int>()
            var howMuchArray = [Int]()
            var totalPaymentAmount = 0
            var userPayment = Int()
            
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                self.numberOfPeople = snapShotDoc.count
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let profileImage = data["profileImage"] as? String,let userName = data["userName"] as? String,let settlement = data["settlement"] as? Bool,let myTotalPaymentAmount = data["myTotalPaymentAmount"] as? Int,let userID = data["userID"] as? String{
                        profileImageArray.append(profileImage)
                        userNameArray.append(userName)
                        settlementArray.append(settlement)
                        //合計金額
                        totalPaymentAmount = totalPaymentAmount + myTotalPaymentAmount
                        //各メンバーの支払った合計金額の配列
                        paymentOfPersonArray.updateValue(myTotalPaymentAmount, forKey: userID)
                    }
                }
                //1人当たりの支出額
                let perPerson = totalPaymentAmount / self.numberOfPeople
                //各メンバーの決済額の配列
                howMuchArray = paymentOfPersonArray.map{($1 - perPerson) * -1}
                //自分の決済額
                userPayment = paymentOfPersonArray[userID]!
                userPayment = perPerson - userPayment
            }
            self.loadOKDelegate?.loadGroupMemberSettlement_OK?(profileImageArray: profileImageArray, userNameArray: userNameArray, settlementArray: settlementArray, howMuchArray: howMuchArray, userPayment: userPayment)
        }
    }
    
    //プロフィール画像変更するロード
    func loadProfileImageChange(groupID:String,userID:String,year:String,newProfileImage:String){
        db.collection(groupID).document(userID).updateData(["profileImage" : newProfileImage])
        db.collection("usersManagement").document(userID).updateData(["profileImage" : newProfileImage])
        db.collection(groupID).document("details").collection(year).whereField("userID", isEqualTo: userID).getDocuments { (snapShot, error) in
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    self.db.collection(groupID).document("details").collection(year).document(doc.documentID).updateData(["profileImage" : newProfileImage])
                }
            }
        }
    }
    
    //ユーザーネーム変更するロード
    func loadUserNameChange(groupID:String,userID:String,year:String,newUserName:String){
        db.collection(groupID).document(userID).updateData(["userName" : newUserName])
        db.collection("usersManagement").document(userID).updateData(["userName" : newUserName])
        db.collection(groupID).document("details").collection(year).whereField("userID", isEqualTo: userID).getDocuments { (snapShot, error) in
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    self.db.collection(groupID).document("details").collection(year).document(doc.documentID).updateData(["userName" : newUserName])
                }
            }
        }
    }
    
    
    
}

