# ZZJModel
  
  ZZJModel是一个超级轻量的JSON转Model的库，你的实体只需要继承自NSObject.而且使用起来也是非常的方面 
  一句代码搞定
  
比如下面这个json 是一组比较复杂的json，对象中嵌套对象 还有数组。对象数组等。
```
{
    "code": 0,
    "msg": "",
    "result": {
        "room": {
            "id": "5",
            "uid": "78",
            "house": 0,
            "start_time": "2015-11-28",
            "city": "上海",
            "region": "长宁",
            "address": "仁达商务楼",
            "summary": "祖安求辅助",
            "pricemin": 3000,
            "moneymin": 2000,
            "longitude": "121.43660700",
            "latitude": "31.21492900",
            "comment_count": 19,
            "photo_count": 7,
            "subway_station": "交通大学",
            "subway_line": "11号线",
            "status": 0,
            "format_time": "11-27",
            "create_time": "04-13",
            "last_modify_time": "2015-11-27 18:33:51",
            "dateDetail": "11月28日入住",
            "pricesection": "预算 2000",
            "cost1": 2000,
            "cost2": null,
            "localization": "长宁 11号线 交通大学",
            "content": "祖安求辅助"
        },
        "content": {
            "id": "5",
            "content": "祖安求辅助",
            "show_content": true
        },
        "show_content": 1233
    }
    ,
    "station": [
                "富锦路",
                "友谊西路",
                "宝安公路",
                "共富新村",
                "呼兰路",
                "通河新村",
                "共康路",
                "彭浦新村",
                "汶水路",
                "上海马戏城",
                "延长路",
                "中山北路",
                "上海火车站",
                "汉中路",
                "新闸路",
                "人民广场",
                "黄陂南路",
                "陕西南路",
                "常熟路",
                "上海图书馆",
                "衡山路",
                "徐家汇",
                "上海体育馆",
                "漕宝路",
                "上海南站",
                "锦江乐园",
                "莲花路",
                "外环路",
                "莘庄"
                ]
    ,"items":[
             {
             "id": "5",
             "content": "测试1",
             "show_content": true
             },
             {
             "id": "6",
             "content": "测试2",
             "show_content": true
             },
             {
             "id": "7",
             "content": "测试3",
             "show_content": false
             }
    ]
}
```


首先 读取JSON，将json转成anyobject或者dictionary都是可以的
除了获取json数据的方法 字典转模型 就一代码
` let all = ZZAll.zz_objToModel(json.object) as ZZAll `

或者 

`let all1 = ZZAll.zz_dicToModel(dic) as ZZAll`

下面这段是用swiftyJSON取的json 详细请下载demo
```
 if let path = NSBundle.mainBundle().pathForResource("test", ofType: "json"){
            let data:NSData?
            do {
                data = try NSData(contentsOfFile: path, options: NSDataReadingOptions())
                let json = JSON(data:data!)
                //任意对象的模型转json  必须是dic
                let all = ZZAll.zz_objToModel(json.object) as ZZAll  //这里需要转一下
                print(all.result?.room?.address)    
                
                if let dic = json.dictionaryObject{
                    
                    let all1 = ZZAll.zz_dicToModel(dic) as ZZAll  //这里需要转一下
                    print(all1.result?.content?.id)

                }
                
            }catch let err {
                debugPrint(err)
            }
        }
```

至于model信息如下
model
```
/// 所有信息
class ZZAll: NSObject{
    
    //MARK: - 属性定义
    var code:NSNumber?
    var msg:String?
    var result:ZZResult?
    var station:[String]?
    var items:[ZZContent]?
    
    /**
     根据Key获取实体相关信息
     
     - returns: 字典
     */
    override func zz_modelPropertyClass()->[String:AnyClass]?{
        return ["result":ZZResult.self,"items":ZZContent.self]  //传入对应类型
    }
    
}
```

如果有对象属性 需要重写zz_modelPropertyClass方法 返回key,对象类型

就这样把所有model 写出来就行了。

```
/// 结果信息
class ZZResult: NSObject{
    
    //MARK: - 属性定义
    var show_content:NSNumber?
    var content:ZZContent?
    var room:ZZRoom?
    

    override func zz_modelPropertyClass()->[String:NSObject]?{
        return ["room":ZZRoom.self,
                "content":ZZContent.self]
    }
}
```

```

/// 内容信息
class ZZContent: NSObject{
    
    //MARK: - 属性定义
    var id:NSNumber?
    var content:String?
    var show_content:Bool?    
}
```

Room 比较雷同 属性较多久不贴了 

使用库的方式也很简单 ，下载代码把NSObject+ZZModel.swift 这个文件copy到你的项目就ok了。
一共200多行代码。超级轻量

目前库还有点问题 ，没办法处理Bool类型，setValue不能给他赋值，objc_setAssociatedObject也没用 。Bool对应的对象类型是NSNumber 这块还在考虑怎么处理 ，如果谁有好的idea，点一下 ，不胜感激！


