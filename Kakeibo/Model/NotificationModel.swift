//
//  NotificationModel.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/11/29.
//

import Foundation
import UserNotifications


class NotificationModel{
    
    func registerNotificarionOfSettlement(groupID:String,settlementDay:String){
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "シェア家計簿"
        content.subtitle = "決済日通知"
        content.body = "本日が決済日のグループがあります！"
        content.userInfo = ["groupID":groupID]
        
        let date = DateComponents(day:Int(settlementDay),hour: 12)
//        let date = DateComponents(day:29,hour: 21,mincd ute: 35)

//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(3), repeats: false)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: groupID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteNotification(identifier:String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
