//
//  SendDBModel.swift
//  Kakeibo
//
//  Created by 都甲裕希 on 2021/10/24.
//

import Foundation
import FirebaseStorage

protocol SendOKDelegate{
    func sendProfileImage_OK(url:String)
}

class SendDBModel{
    
    var sendOKDelegate:SendOKDelegate?
    
    func sendProfileImage(data:Data){
        let image = UIImage(data: data)
        let profileImage = image?.jpegData(compressionQuality: 0.1)
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        imageRef.putData(profileImage!, metadata: nil) { (mataData, error) in
            if error != nil{
                return
            }
            imageRef.downloadURL { (url, error) in
                if error != nil{
                    return
                }
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
                self.sendOKDelegate?.sendProfileImage_OK(url: url!.absoluteString)
                
            }
        }
    }
}
