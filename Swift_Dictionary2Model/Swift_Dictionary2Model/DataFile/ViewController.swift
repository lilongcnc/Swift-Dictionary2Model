//
//  ViewController.swift
//  0303-Dictionary2Model
//
//  Created by 李龙 on 15/3/4.
//  Copyright (c) 2015年 Lauren. All rights reserved.
//

///*************   测试工具类    ********************

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        testModelInfo()
        
        //获取jion数据,返回为字典
        let json = loadJSONFile()
//        println(json)
        //把json中的字典数据赋值给模型
        let obj = SwiftDictModel.sharedManager.ObjectWithDictionary(json,cls:subModel.self) as! subModel
        
        println("---->>>" + obj.info!.name!)
        
        println("OTHER")
        for value in obj.other! {
            println(value.name)
        }
        
        println("OTHERS")
        for value in obj.others! {
            let o = value as! Info
            println(o.name)
        }
        
        println("Demo \(obj.demo!)")
        
        
    }
    
    //测试模型信息
    func testModelInfo(){
//        println(loadJSONFile())
        
        let tool = SwiftDictModel()
//        tool.modelInfo(Model.self) //**** 可以看出swift中，命名空间的概念，不用import,但是注意命名空间是否勾选到你要引用的文件范围内
        
        println("模型字典1是：\(tool.fullModleInfo(subModel.self))")
        println("模型字典2是：\(tool.fullModleInfo(subModel.self))")
        println("模型字典3是：\(tool.fullModleInfo(Model.self))")
        
    }


    
    //第一步： 获取字典
    func loadJSONFile() -> NSDictionary {
        let path = NSBundle.mainBundle().pathForResource("Model01.json", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        //JSONObjectWithData返回的是一个Anyobject
        let json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.allZeros, error: nil) as! NSDictionary
        
        return json
    }
    
}

