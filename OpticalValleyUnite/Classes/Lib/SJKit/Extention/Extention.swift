//
//  Extention.swift
//  qimiaozhenxiang
//
//  Created by 贺思佳 on 2016/9/22.
//  Copyright © 2016年 Roger. All rights reserved.
//

import Foundation
import UIKit


let SJKeyWindow = UIApplication.shared.keyWindow ?? (UIApplication.shared.delegate as! AppDelegate).window
let SJScreeW = UIScreen.main.bounds.size.width
let SJScreeH = UIScreen.main.bounds.size.height




extension Date{
    /**
     把给定时间按照指定格式转化为字符串
     
     - parameter date:   需要转换的时候 不填默认为当前时间
     - parameter formet: 字符串时间格式"yyyy-MM-dd HH:mm:ss"
     
     - returns: 转化后的时间字符串
     */
    static func dateStringDate(date :Date = Date(), dateFormetString formet :String) ->String{
        
        let dateFormet = DateFormatter()
        dateFormet.dateFormat = formet
        return dateFormet.string(from: date)
    }
    
    static func getDaysInMonth( year: Int, month: Int) -> Int
    {
        let calendar = Calendar.current
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        
        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = month == 12 ? 1 : month + 1
        endComps.year = month == 12 ? year + 1 : year
        
        let startDate = calendar.date(from: startComps)!
        let endDate = calendar.date(from: endComps)!
        
//        let diff = calendar.components(.Day, fromDate: startDate, toDate: endDate,
//                                       options: .MatchFirst)
        let diff = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return diff.day!
    }
    
    static func dateFromString(dateStr :String, formetStr : String) ->Date{
        let dateFormet = DateFormatter()
        dateFormet.dateFormat = formetStr
        return dateFormet.date(from: dateStr)!
    }
    func dateCompoents() -> DateComponents {
//        let flags:  = [.day]
        
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
    }
    
    func dataString(dateFormetStr :String) -> String{
       return Date.dateStringDate(date: self, dateFormetString: dateFormetStr)
    }

    //加一天
    func dateAddOneDay(count: Int = 1) -> Date{

        var dateCom = DateComponents()
        dateCom.day = count
        
      return  Calendar.current.date(byAdding: dateCom, to: self)!

    }

    //减一天
    func dateSubtractingOneDay(count: Int = 1) -> Date{
        let timeInter = self.timeIntervalSince1970 - TimeInterval(3600 * count * 24)
        return Date(timeIntervalSince1970: timeInter)
    }
}


extension UILabel{
    func ranged(range: NSRange, color: UIColor?, fontNumber: CGFloat?){
        let str = NSMutableAttributedString(string: text!)
        if fontNumber != nil {
            str.addAttributes([NSForegroundColorAttributeName: fontNumber!], range: range)
        }
        
        if color != nil {
            str.addAttribute(NSForegroundColorAttributeName, value: color!, range: range)
        }
        self.attributedText = str
    }
    
    func contentString(contentStr: String, color: UIColor){
        let range = (text! as NSString).range(of: contentStr)
        ranged(range: range, color: color, fontNumber: nil)
    }
}

extension UIColor{
    
    class func colorFromRGB(rgbValue: UInt) -> UIColor {
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}



extension NSObject {
    
    private struct associatedKeys {
        static var safe_observersArray = "observers"
    }
    
    
    private var observers: [[String : NSObject]] {
        get {
            if let observers = objc_getAssociatedObject(self, &associatedKeys.safe_observersArray) as? [[String : NSObject]] {
                return observers
            } else {
                self.observers = [[String : NSObject]]()
                return self.observers
            }
        } set {
            objc_setAssociatedObject(self, &associatedKeys.safe_observersArray, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    public func safe_addObserver(observer: NSObject, forKeyPath keyPath: String) {
        let observerInfo = [keyPath : observer]
        
        if observers.index(where: { $0 == observerInfo }) == nil {
            observers.append(observerInfo)
            addObserver(observer, forKeyPath: keyPath, options: .new, context: nil)
        }
    }
    
    public func safe_removeObserver(observer: NSObject, forKeyPath keyPath: String) {
        let observerInfo = [keyPath : observer]
        if let index = observers.index(where: { $0 == observerInfo}) {
            observers.remove(at: index)
            removeObserver(observer, forKeyPath: keyPath)
        }
    }
}


extension UIStoryboard{
    class func instantiateInitialViewController(name: String) -> UIViewController{
        let storyBoard = UIStoryboard.init(name: name, bundle: nil)
        
        return storyBoard.instantiateInitialViewController()!
    }
}

extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        

        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        
        return String(format: hash as String)
    }
}

extension UITableView{
    func animateTable(duration: TimeInterval = 1.0 ) {
        self.reloadData()
        
        let cells = self.visibleCells
        let tableHeight = self.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        for cell in cells {
            UIView.animate(withDuration: duration, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            index += 1
        }
    }
}

extension UIViewController{
    class func loadFromMainStoryboard() -> UIViewController{
        return self.loadFromStoryboard(name: "Main")
    }
    
    class func loadFromStoryboard(name: String) -> UIViewController{
        let className = NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
        let storyBoard = UIStoryboard.init(name: name, bundle: nil)
        
        
        return storyBoard.instantiateViewController(withIdentifier: className)
    }
    
    
    
    func alert(message: String) {
        let alc = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alc.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alc, animated: true, completion: nil)
    }
    
    func alert(message: String, doneBlock: @escaping ((UIAlertAction)->())) {
        let alc = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alc.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil))
        alc.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: doneBlock))
        self.present(alc, animated: true, completion: nil)
    }
    
    func alert(message: String, doneBlock: @escaping ((UIAlertAction)->()),cancleBlock: @escaping ((UIAlertAction)->())) {
        let alc = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alc.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: cancleBlock))
        alc.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: doneBlock))
        
        self.present(alc, animated: true, completion: nil)
    }
}

extension UIView{
    

    class func loadFromXib() -> UIView{
        
        let className = NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
        return Bundle.main.loadNibNamed(className, owner: nil, options: nil)?.first as! UIView
    }
    
    
    
}


protocol RandomNumType{
    associatedtype Element
    func random() -> Element
}

extension Int: RandomNumType{
    typealias Element = Int

    func random() -> Element {
        return Int(arc4random_uniform(UInt32(self)))
    }
    
    func stringValue() -> String?{
        return "\(self)"
    }
}

extension Array: RandomNumType{
    func random() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

extension Array where Element: Equatable{
    //数组元素随机打乱
    func upset() -> Array{
        var arry = self
        var result: [Element] = []
        for _ in 0 ..< arry.count{
            let element = arry.random()
            result.append(element)
            let index = arry.index(where: {$0 == element})
            if let index = index {
                arry.remove(at: index)
            }
        }
        return result
    }
}

//MARK: - 遵守这个协议后,控制台可以打印模型的属性值
extension CustomStringConvertible{
    var description: String{
        let mirror = Mirror(reflecting: self)
        var des = ""
        for p in mirror.children {
            let propertyNameString = p.label! //属性名使用!，因为label是optional类型
            let value = p.value //属性的值
            print()
            des.append("\(propertyNameString)的值为\(value)\n")
        }
        return des
    }
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}


public extension FileManager{
    static func documentsURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}


public extension UIImage{

    func addContent(content: String, frame: CGRect) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        self.draw(at: CGPoint.zero)
        let dic = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont.systemFont(ofSize: 40)]
        let str = content as NSString
        str.draw(in: frame, withAttributes: dic)
        let imageNew = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return imageNew!;
    }
}


