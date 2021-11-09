//
//  EditDBModel.swift
//  Kakeibo
//
//  Created by 都甲裕希 on 2021/11/04.
//

import Foundation
import Firebase
import FirebaseFirestore

@objc protocol EditOKDelegate {
    @objc optional func editGroupInfoDelete_OK()
    @objc optional func editMonthDetailsDelete_OK()
    @objc optional func editProfileImageChange_OK()
    @objc optional func editUserNameChange_OK()
    @objc optional func editUserDelete_OK()
}

class EditDBModel{
    
    var editOKDelegate:EditOKDelegate?
    var db = Firestore.firestore()
    var monthMyDetailsSets:[MonthMyDetailsSets] = []
    let dateFormatter = DateFormatter()
    
    //招待を受けているグループで拒否ボタンを押したときのロード
    func editGroupInfoDelete(groupID:String,userID:String,activityIndicatorView:UIActivityIndicatorView){
        db.collection("groupManagement").document(groupID).getDocument { (snapShot, error) in
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let data = snapShot?.data(){
                var joinGroupDic = data["joinGroupDic"] as! Dictionary<String,Bool>
                joinGroupDic.removeValue(forKey: userID)
                self.db.collection("groupManagement").document(groupID).updateData(["joinGroupDic" : joinGroupDic])
                self.editOKDelegate?.editGroupInfoDelete_OK?()
            }
            activityIndicatorView.stopAnimating()
        }
    }
    
    //自分の明細を削除したときにロード
    func editMonthDetailsDelete(groupID:String,userID:String,startDate:Date,endDate:Date,index:Int,activityIndicatorView:UIActivityIndicatorView){
        db.collection(groupID).whereField("userID", isEqualTo: userID).whereField("paymentDay", isGreaterThan: startDate).whereField("paymentDay", isLessThanOrEqualTo: endDate).order(by: "paymentDay").getDocuments { (snapShot, error) in
            self.monthMyDetailsSets = []
            self.dateFormatter.dateFormat = "yyyy/MM/dd"
            self.dateFormatter.locale = Locale(identifier: "ja_JP")
            self.dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let snapShotDoc = snapShot?.documents{
                var count = 0
                for doc in snapShotDoc{
                    let data = doc.data()
                    let productName = data["productName"] as! String
                    let paymentAmount = data["paymentAmount"] as! Int
                    let date = data["paymentDay"] as! Date
                    let category = data["category"] as! String
                    let userID = data["userID"] as! String
                    let paymentDay = self.dateFormatter.string(from: date)
                    if count == index{
                        self.db.collection(groupID).document(doc.documentID).delete()
                    }else{
                        let myNewData = MonthMyDetailsSets(productName: productName, paymentAmount: paymentAmount, paymentDay: paymentDay, category: category, userID: userID)
                        self.monthMyDetailsSets.append(myNewData)
                    }
                    count = count + 1
                }
            }
            self.editOKDelegate?.editMonthDetailsDelete_OK?()
        }
    }
    
    //プロフィール画像変更するロード
    func editProfileImageChange(userID:String,newProfileImage:String){
        db.collection("userManagement").document(userID).updateData(["profileImage" : newProfileImage])
        db.collection("groupManagement").whereField("profileImageDic", isEqualTo: [[userID]]).getDocuments { (snapShot, error) in
            if error != nil{
                return
            }
            if let snapShotDic = snapShot?.documents{
                for doc in snapShotDic{
                    self.db.collection("groupManagement").document(doc.documentID).setData(["profileImageDic" : [userID:newProfileImage]],merge: true)
                }
            }
            self.editOKDelegate?.editProfileImageChange_OK?()
        }
    }
    
    //ユーザーネーム変更するロード
    func editUserNameChange(userID:String,newUserName:String){
        db.collection("userManagement").document(userID).updateData(["userName" : newUserName])
        db.collection("groupManagement").whereField("userNameDic", isEqualTo: [[userID]]).getDocuments { (snapShot, error) in
            if error != nil{
                return
            }
            if let snapShotDic = snapShot?.documents{
                for doc in snapShotDic{
                    self.db.collection("groupManagement").document(doc.documentID).setData(["userNameDic" : [userID:newUserName]],merge: true)
                }
            }
            self.editOKDelegate?.editUserNameChange_OK?()
        }
    }
    
    //ユーザーが退会したときのロード
    func editUserDelete(groupID:String,userID:String,activityIndicatorView:UIActivityIndicatorView){
        db.collection("groupManagement").document(groupID).getDocument { (snapShot, error) in
            if error != nil{
                activityIndicatorView.stopAnimating()
                return
            }
            if let data = snapShot?.data(){
                var joinGroupDic = data["joinGroupDic"] as! Dictionary<String,Bool>
                var userNameDic = data["userNameDic"] as! Dictionary<String,String>
                var settlementDic = data["settlementDic"] as! Dictionary<String,Bool>
                var myTotalPaymentAmountDic = data["myTotalPaymentAmountDic"] as! Dictionary<String,Int>
                var profileImageDic = data["profileImageDic"] as! Dictionary<String,String>
                joinGroupDic.removeValue(forKey: userID)
                userNameDic.removeValue(forKey: userID)
                settlementDic.removeValue(forKey: userID)
                myTotalPaymentAmountDic.removeValue(forKey: userID)
                profileImageDic.removeValue(forKey: userID)
                self.db.collection("groupManagement").document(groupID).updateData(["joinGroupDic" : joinGroupDic,"userNameDic" : userNameDic,"settlementDic" : settlementDic,"myTotalPaymentAmountDic" : myTotalPaymentAmountDic,"profileImageDic" : profileImageDic])
                self.editOKDelegate?.editUserDelete_OK?()
            }
            activityIndicatorView.stopAnimating()
        }
    }
}
