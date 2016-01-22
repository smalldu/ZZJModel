//
//  ZZAll.swift
//  ZZJModel
//
//  Created by duzhe on 16/1/22.
//  Copyright © 2016年 dz. All rights reserved.
//

import Foundation


/// 所有信息
class ZZAll: NSObject{
    
    //MARK: - 属性定义
    var code:NSNumber?
    var msg:String?
    var result:ZZResult?
    

    
    /**
     根据Key获取实体相关信息
     
     - returns: 字典
     */
    override func zz_modelPropertyClass()->[String:NSObject]?{
        return ["result":ZZResult()]
    }
    
}