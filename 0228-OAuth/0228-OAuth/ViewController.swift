//
//  ViewController.swift
//  0228-OAuth
//
//  Created by 李龙 on 15/2/28.
//  Copyright (c) 2015年 Lauren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView()
        
    
    }
    
    func loadWebView()->(){
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=2105659899&redirect_uri=http://www.baidu.com"
//let urlString = "https:/www.baidu.com"
        let url = NSURL(string: urlString)
        myWebView.loadRequest(NSURLRequest(URL: url!))
    }
    
}

extension ViewController : UIWebViewDelegate{
    //** 从获取的url当中获取code*/
    
    //重定向函数
    //接收每次webView发送的请求
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
    
        println(request.URL)
        if let code = requestCode(request.URL!) {
            
            println(code)
            
            //获取accesstoken
            let urlString = "https://api.weibo.com/oauth2/access_token"
            let url = NSURL(string: urlString)
            let req = NSMutableURLRequest(URL: url!)
            
            //请求方式
            req.HTTPMethod = "POST"
        
            //定义request的请求参数
            var bodyStr = "client_id=2105659899&client_secret=8207985f2251507de62c0e3374d1e6d1&redirect_uri=http://www.baidu.com&grant_type=authorization_code&code=\(code)"
            req.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            
            NSURLSession.sharedSession().dataTaskWithRequest(req as NSURLRequest, completionHandler: { (data, _, _) -> Void in
                //反序列化
                let dict : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
                
//                dict?.writeToFile("/Users/lilong/Desktop/weibo.json", atomically: true, encoding: NSUTF8StringEncoding, error: nil)
                println(dict)
            }).resume()
        }
        
        
        return true
    }
    
    
    //从返回的地址中，获取code
    //有code直接从返回，没有返回nil
    func requestCode(url : NSURL) ->String?{
        println(url)
        if let query = url.query{
            if query.hasPrefix("code="){
             //取子串
                var code:NSString = "code="
                return (query as NSString).substringFromIndex(code.length)
            }
        }
        return nil
    }
    
}

