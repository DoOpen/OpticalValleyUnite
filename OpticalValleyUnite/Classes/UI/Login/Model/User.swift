//
//  User.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/3/16.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

public struct UserKey {
    static let UserID = "usrid"
    static let Username = "LOGIN_NAME"
    static let UsernameType = "method"
    static let AvatarImageType = "fileExt"
    static let SMSCode = "verifyCode"
    static let WeChat = "wx"
    static let UID = "uid"
    static let Nickname = "NICKNAME"
    static let Password = "pwd"
    static let Email = "email"
    static let Mobile = "phone"
    static let Age = "age"
    static let Avatar = "USER_ICON"
    static let Mail = "mail"
    static let QQ = "qq"
    static let Level = "level"
    static let RegisterTime = "regTime"
    static let Description = "descp"
    static let Sex = "sex"
    static let Location = "location"
    static let DetailAddress = "address"
    static let UserFileKey = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/account.data")
}

class User: NSObject, NSCoding {
   
    
    static var _currentUser :User?
    
    class func saveUser(user :User){
        User._currentUser = user
        NSKeyedArchiver.archiveRootObject(user, toFile: UserKey.UserFileKey)
    }
    
    class func removeUser(){
//        User._currentUser = nil
//        NSKeyedArchiver.archiveRootObject(user, toFile: UserKey.UserFileKey)
        do{
            try? FileManager.default.removeItem(atPath: UserKey.UserFileKey)
        }
        
    }
    
    func saveUser(){
        
        User._currentUser = self
        NSKeyedArchiver.archiveRootObject(self, toFile: UserKey.UserFileKey)
    }
    
    class func isLogin() -> Bool{
        return UserDefaults.standard.object(forKey: Const.SJToken) != nil
    }
    
    
    class func currentUser() -> User?{
        if(User._currentUser == nil){
            
            User._currentUser = NSKeyedUnarchiver.unarchiveObject(withFile: UserKey.UserFileKey) as? User
            
        }else{
            return User._currentUser
        }
        return User._currentUser
    }
    
    var nickname: String?
    var avatar: String?
    var userName: String?
    
    //    let name: String = ""
    

    init?(data: [String: Any]){
       
            self.nickname = data[UserKey.Nickname] as? String
            self.avatar = data[UserKey.Avatar] as? String
            self.userName = data[UserKey.Username] as? String
        
    }
    
    
    required init(coder decoder: NSCoder) {
        super.init()

        self.nickname = decoder.decodeObject(forKey: "nickname")as? String
        self.avatar = decoder.decodeObject(forKey: "avatar") as? String
        self.userName = decoder.decodeObject(forKey: "userName") as? String

    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(userName, forKey: "userName")
    }
    
    
    
}
