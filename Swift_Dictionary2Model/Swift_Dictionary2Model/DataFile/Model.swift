//
//  Model.swift
//  0303-Dictionary2Model
//
//  Created by 李龙 on 15/3/4.
//  Copyright (c) 2015年 Lauren. All rights reserved.
//

import Foundation

//MARK 这里必须继承 DIctModelProtocl协议
class Model : NSObject,DictModelProtocl {
    
    var str1 : String? //我们有可能定义为这个
    var str2 : NSString? //我们有可能定为这个
    var b : Bool = true
    var i : Int = 0
    var f : Float = 0
    var d : Double = 0
    var num : NSNumber?
    
    var info : Info?
    var other : [Info]?
    var others : NSArray?
    
    //数组嵌套数组
    var demo : NSArray?  //或者[[info]]?
    

    //模仿MJExtection 来写协议方法
    // 这里的作用是告诉 工具类，当前模型类中对象的映射关系
    static func customeClassMapping() -> [String : String]? {
        //返回：定义对象的映射关系，指定属性对象的类型
        return ["info" : "\(Info.self)" , "other" : "\(Info.self)", "others" :  "\(Info.self)","demo" : "\(Info.self)"]
    }
}

class subModel : Model {
   var boy: String?
}

class Info: NSObject {
    var name : String?
}

