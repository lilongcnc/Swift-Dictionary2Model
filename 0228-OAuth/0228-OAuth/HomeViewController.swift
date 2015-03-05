//
//  HomeViewController.swift
//  0228-OAuth
//
//  Created by 李龙 on 15/3/1.
//  Copyright (c) 2015年 Lauren. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //加载微博
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00ZoCujB81IVSC8f495f63b2Rr6HUD"
        
        let url = NSURL(string: urlString)
        
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, _, _) -> Void in
            let result : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
            
            data.writeToFile("Users/lilong/Desktop/status.json", atomically: true)
            
            println(result)
        }).resume()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
