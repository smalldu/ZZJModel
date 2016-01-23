//
//  ViewController.swift
//  ZZJModel
//
//  Created by duzhe on 16/1/22.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let path = NSBundle.mainBundle().pathForResource("test", ofType: "json"){
            let data:NSData?
            do {
                data = try NSData(contentsOfFile: path, options: NSDataReadingOptions())
                let json = JSON(data:data!)
                //任意对象的模型转json  必须是dic
                print(json)
                
                let all = ZZAll.zz_objToModel(json.object) as ZZAll  //这里需要转一下
                print(all.result)
                
                if let dic = json.dictionaryObject{
                    
                    let all1 = ZZAll.zz_dicToModel(dic) as ZZAll  //这里需要转一下
                    print(all1.items?[0].id)

                }
                
            }catch let err {
                debugPrint(err)
            }
        }
        
        
//       let  a = (A.self as NSObject.Type).init()
//        a.setValue("a", forKey: "item")
//        print(a.valueForKey("item"))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



class  A:NSObject{
    
    var item:String?
    
//    override init() {
//        super.init()
//    }
//    
}

//已知 A.self(返回AnyObject) 怎么给item赋值

// 如何创建A对象






