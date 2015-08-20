//
//  ViewController.swift
//  example01
//
//  Created by green on 15/8/20.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var dataSource : [String:[[String:String]]]!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        // 打印
        // println(NSDictionary(dictionary: dataSource).descriptionWithLocale(nil))
        // println(dataSource.keys.array)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - setup
    
    private func setup() {
    
        // 设置数据源
        setupDataSource()
        
    }

    /**
     * 加载数据源
     */
    private func setupDataSource() {
        
        // 单例
        struct DataSourceSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:[String:[[String:String]]]!
        }
        
        dispatch_once(&DataSourceSingleton.predicate, { () -> Void in
            
            DataSourceSingleton.instance = [String:[[String:String]]]()
            
            let filePath = NSBundle.mainBundle().pathForResource("data", ofType: "json")!
            let data     = NSFileManager.defaultManager().contentsAtPath(filePath)
            var error:NSError?
            if let data = data {
                
                DataSourceSingleton.instance = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? [String:[[String:String]]]
            }
        })
        
        // 设置数据源
        dataSource = DataSourceSingleton.instance
    }
}

