//
//  ZZResult.swift
//  ZZJModel
//
//  Created by duzhe on 16/1/22.
//  Copyright © 2016年 dz. All rights reserved.
//

import Foundation
/// 结果信息
class ZZResult: NSObject{
    
    //MARK: - 属性定义
    var show_content:NSNumber?
    var content:ZZContent?
    var room:ZZRoom?
    

    override func zz_modelPropertyClass()->[String:NSObject]?{
        return ["room":ZZRoom(),
                "content":ZZContent()]
    }
}