//
//  SwiftDictModel.swift
//  0303-Dictionary2Model
//
//  Created by 李龙 on 15/3/4.
//  Copyright (c) 2015年 Lauren. All rights reserved.
//

///****************   字典转模型工具类V1.0 特别感谢：刀哥  *******************

import Foundation


//字典转模型的协议
@objc protocol DictModelProtocl {
    
    //ST1.2之后定义 类方法 是 用static 替换 class
    static func customeClassMapping() -> [String : String]?
    
}

class SwiftDictModel {
    
// -----------     开始字典转模型    ----------
    static let sharedManager = SwiftDictModel()

    
    ///  将字典转换成模型对象，适用于有父类的情况，把父类和子类的对象全部转换
    ///
    ///  :param: dict 模型类对应的数据字典
    ///  :param: cls  模型类
    ///
    ///  :returns: 实例化的类对象
    func ObjectWithDictionary(dict : NSDictionary,cls : AnyClass) -> AnyObject?{
        
        let dictInfo = fullModleInfo(cls)
        
        var obj : AnyObject = cls.alloc()
        
        for(k, v) in dictInfo {
            if let value: AnyObject = dict[k]{
                if v.isEmpty && !(value === NSNull()){
                    obj.setValue(value, forKey: k)
                }else{
                    //这里转成字符串
                    let type = "\(value.classForCoder)"
                    
                    if type == "NSDictionary"{
                        //进入这里，说明value是字典，那么继续value做 字典转模型操作，调用本类
                        if let subObj:AnyObject? = ObjectWithDictionary(value as! NSDictionary, cls: NSClassFromString(v)) {
                            //到了这里 第二层模型对象 就是可以直接用KVC赋值了
                            obj.setValue(subObj, forKey: k)
                        }
                    }else if type == "NSArray"{
                        //value 是数组
                        if let subObj:AnyObject? = objectWithArray(value as! NSArray, cls: NSClassFromString(v)){
                            obj.setValue(subObj, forKey: k)
                        }
                        
                    }
                }
                
            }
        }
        
        println(dictInfo)
        
        return obj
    }
    
    
    ///  将数组转换成模型字典，适用于单个模型类
    ///
    ///  :param: array 数组的描述
    ///  :param: cls 模型类
    ///
    ///  :returns: 模型数组
    func objectWithArray(array : NSArray,cls : AnyClass) -> [AnyObject]? {
        
        //创建一个数组
        var result = [AnyObject]()
        
        //遍历数组
        for value in array {
            let type = "\(value.classForCoder)"
            
            if type == "NSDictionary"{
                if let subObj: AnyObject = ObjectWithDictionary(value as! NSDictionary, cls: cls){
                    result.append(subObj)
                }
                
            }else if type == "NSArray"{
                if let subObj: AnyObject = objectWithArray(value as! NSArray, cls: cls){
                 result.append(subObj)
                }
            }
        }
        
        return result
    }
    
    
// ----------- 获取模型类的 信息 ----------
    
    //缓存字典，类的模型信息获取到，就不在再调用下边的各类方法去获取，节省性能
    //格式： [ 类名1 ：模型字典,...... ]
    var modelCache = [String : [String : String]]()

    
    //获取模型类完整的信息(有子类和父类的情况，传入子类)
    func fullModleInfo(cls : AnyClass) -> [String : String] {
    
        //判断类信息是否已经被缓存
        if let cache = modelCache["\(cls)"] {
            println("已经被缓存 -------- \(cls)")
            return cache
        }
        
        //模型字典
        var dictInfo = [String :String]()
        
        //循环查找父类
        var currntCls : AnyClass = cls
        while let parent : AnyClass = currntCls.superclass() {
            println("\(currntCls)------ \(parent)")
            
            //把子类和父类的字典合并在一起
            dictInfo.merge(modelInfo(currntCls))
            
            currntCls = parent
        }
        
        //将模型信息存入缓存
        modelCache["\(cls)"] = dictInfo
        
        return dictInfo
    }

    
    ///  获取一个具体类的 模型信息 （没有子类的情况）
    func modelInfo(cls : AnyClass) -> [String: String]{
        
        //判断类信息是否已经被缓存
        if let cache = modelCache["\(cls)"] {
            println("已经被缓存 -------- \(cls)")
            return cache
        }
        
        //判断模型类是否遵守了协议,一旦遵守了协议，就说明有自定义对象
        var mapping : [String : String]?
        if cls.respondsToSelector("customeClassMapping"){
            mapping = cls.customeClassMapping()
            println(mapping)
        }
        
        
        // count 获取类中属性的个数
        var count : UInt32 = 0
        let ivars = class_copyIvarList(cls, &count) //UnsafeMutablePointe 即OC中的 **
        
        //定义一个字典， 来存储 有属性和自定义对象类型（如果有的话） ，没有自定义类型的话，那么就为空
        var dictInfo = [String : String]()
        
        
        for i in 0..<count{
            let ivar = ivars[Int(i)]
            //获取属性名字
            let cname = ivar_getName(ivar)
            //转成swift的string
            let name = String.fromCString(cname)! //这里加 ！,打印没有了'Optional()'
            
            let type = mapping?[name] ?? ""
            
            //设置该name字典
            dictInfo[name] = type
            
            println(name + "--" + type)
        }
        
        //释放上边copy的对象
        free(ivars)
        
        //将模型信息存入缓存
        modelCache["\(cls)"] = dictInfo
        
//        println(count)
//        println(dictInfo)
        return dictInfo
    }
}


//分类，给Dictionary添加方法
extension Dictionary{
    mutating func merge<k,v> (dict : [k : v]){
        for (k,v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}




