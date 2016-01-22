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
                let all = ZZAll.zz_objToModel(json.object) as ZZAll  //这里需要转一下
                print(all.result?.room?.address)    
                
                if let dic = json.dictionaryObject{
                    
                    let all1 = ZZAll.zz_dicToModel(dic) as ZZAll  //这里需要转一下
                    print(all1.result?.content?.id)

                }
                
            }catch let err {
                debugPrint(err)
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

