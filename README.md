# ZZJModel


库是为了把一些繁琐的操作变的更简单，说白了就是封装。

Json转Model 也有一些库了，我写这个简单的库就练练手，其他库我也没用过，（项目中还是半自动，手写转的）。

简单介绍下ZZJModel，就是将Json类型的数据一行代码转成对象。对json不了解的 自行google。

这里有一组json
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
}
```

这组json看来 整体是一个对象 中间还有一个room对象和content对象。手动转肯定要写很多for循环。那么 我这个库呢？

首先 读取JSON，我这些字串放在.json文件中，用SwiftyJSON读取， 后面我有可能会直接考虑加上data转model 现在不会加

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

除了获取json数据的方法 字典转模型 就一句话 
` let all = ZZAll.zz_objToModel(json.object) as ZZAll `

或者 

`let all1 = ZZAll.zz_dicToModel(dic) as ZZAll`

这样就可以打印对象中的信息 包括对象中的对象的属性
` print(all.result?.room?.address) `

有两种调用方式  一种是传入AnyObject 一种是传入[String:AnyObject] 

git上大多数库的model都是要继承第三方J�S�ON转Model的库的 ，我们这里 不用 

model
```
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
```

如果有对象属性 需要重写zz_modelPropertyClass方法 返回key,value


就这样把所有model 写出来就行了。

```
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

目前库还有点问题 ，没办法处理Bool类型，setValue不能给他赋值，objc_setAssociatedObject也没用 。Bool对应的对象类型是NSNumber 这块还在考虑怎么处理 ，毕竟非科班出身，毕竟太菜。如果谁有好的idea，点一下 ，不胜感激！

那么怎么实现的呢，也很简单就一个文件

![贴图](http://upload-images.jianshu.io/upload_images/954071-39bffda53ded58c5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

总共就200行代码 ，感兴趣的同学可以看看。
