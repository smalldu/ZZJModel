//
//  NSObject+Add.swift
//  ZZJModel
//
//  Created by duzhe on 16/1/22.
//  Copyright © 2016年 dz. All rights reserved.
//

import Foundation


/**
 数据类型
 */
public enum zz_type :Int{
    case Number
    case String
    case Bool
    case Array
    case Dictionary
    case Null
    case Unknown
}


extension NSObject{
    
    /**
     任意类型  如果传入的是任意类型 主动转成字典 如果不成功返回空对象
     
     - parameter obj: 任意对象
     
     - returns: 模型
     */
    static func zz_objToModel<T:NSObject>(obj:AnyObject?)->T{
        if let dic = obj as? [String:AnyObject]{
            return zz_dicToModel(dic)
        }
        return T()
    }
    
    /**
     字典转模型
     
     - parameter dic: 字典
     - returns: 模型
     */
    static func zz_dicToModel<T:NSObject>(dic:[String:AnyObject])->T{
        let t = T()
//        print(self.classForCoder())
        for (k,v) in dic{
            if t.zz_getVariableWithClass(T.self, varName: k){ //如果存在这个属性
                if t.zz_isBasic(t.zz_getType(v)){
//                    print(t.classForCoder)
                    //基础类型 可以直接赋值
//                    print("\(k)--\(v)--\(t.zz_getType(v))")
                    t.setValue(v,forKey: k)
                }else{
                    //复杂类型
                    if t.zz_getType(v) == .Dictionary{
                        //是一个对象类型
                        if let dic1 = v as? [String : AnyObject]{
                            if t.respondsToSelector("zz_modelPropertyClass"){
                                if let properties = t.zz_modelPropertyClass(){
                                    if  t.valueForKey(k) == nil{
                                        //初始化
                                        t.setValue(properties[k], forKey: k)
                                    }
                                }
                            }
                            if let obj = t.valueForKey(k){
                                obj.setDicValue(dic1) //有对象就递归
                            }
                        }
//                        print(v)
                    }
                }
            
            }
        }
        return t
    }
    
    
    /**
     逐级递归 遍历赋值给对象
     
     - parameter dic1: 字典
     */
    func setDicValue(dic1:[String : AnyObject]){
        for (k,v) in dic1{
            
            if self.zz_getVariableWithClass(self.classForCoder, varName: k){
                //判断是否存在这个属性
                if self.zz_isBasic(self.zz_getType(v)){
                    //设置基本类型
                    
                    if self.zz_getType(v) == .Bool{
                        
                        //TODO: -Bool类型怎么处理  不懂
//                        self.setValue(Bool(v as! NSNumber), forKey: k)
                        
                    }else{
                        self.setValue(v, forKey: k)
                    }
                    
                    
                }else if self.zz_getType(v) == .Dictionary{
                    if let dic1 = v as? [String : AnyObject]{
                        if self.respondsToSelector("zz_modelPropertyClass"){
                            if let properties = self.zz_modelPropertyClass(){
                                if  self.valueForKey(k) == nil{
                                    //初始化
                                    self.setValue(properties[k], forKey: k)
                                }
                            }
                        }
                        if let obj = self.valueForKey(k){
                            obj.setDicValue(dic1) //递归
                        }
                    }
                }
                
            }
        }
    }
    
    
    
    /**
     判断类型
     
     - parameter v: 参数
     
     - returns: 类型
     */
     private func zz_getType(v:AnyObject)->zz_type{
        switch v{
        case let number as NSNumber:
            if number.isBool {
                return .Bool
            } else {
                return .Number
            }
        case _ as String:
            return .String
        case _ as NSNull:
            return .Null
        case _ as [AnyObject]:
            return .Array
        case _ as [String : AnyObject]:
            return .Dictionary
        default:
            return .Unknown
        }
    }
    
    
    /**
     是否为基础类型
     
     - parameter type: 类型
     
     - returns: true/false
     */
    private func zz_isBasic(type:zz_type)->Bool{
        if type == .Bool || type == .String || type == .Number {
            return true
        }
        return false
    }
    
    /**
     留给子类有实体属性的去继承
     
     - returns: k , 实体
     */
    func zz_modelPropertyClass()->[String:NSObject]?{
        return nil
    }
   
    /**
     判断对象中是否包含某个属性
     
     - parameter cla:     类
     - parameter varName: 变量名
     
     - returns: bool
     */
    func zz_getVariableWithClass(cla:AnyClass , varName:String)->Bool{
        var outCount:UInt32 = 0
        let ivars = class_copyIvarList(cla, &outCount)
        for i in 0..<outCount{
            let property = ivars[Int(i)]
            let keyName = String.fromCString(ivar_getName(property))
            if keyName == varName{
                free(ivars)
                return true
            }
        }
        free(ivars)
        return false
    }
    
}

private let zz_trueNumber = NSNumber(bool: true)
private let zz_falseNumber = NSNumber(bool: false)
private let zz_trueObjCType = String.fromCString(zz_trueNumber.objCType)
private let zz_falseObjCType = String.fromCString(zz_falseNumber.objCType)
// MARK: - 判断是否为bool
extension NSNumber {
    var zz_isBool:Bool {
        get {
            let objCType = String.fromCString(self.objCType)
            if (self.compare(zz_trueNumber) == NSComparisonResult.OrderedSame && objCType == zz_trueObjCType)
                || (self.compare(zz_falseNumber) == NSComparisonResult.OrderedSame && objCType == zz_falseObjCType){
                    return true
            } else {
                return false
            }
        }
    }
}
