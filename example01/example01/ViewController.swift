//
//  ViewController.swift
//  example01
//
//  Created by green on 15/8/20.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var dataSource      : [String:[[String:String]]]!
    private var collectionView  : UICollectionView!
    
    let kCellIdentifier           = "CellIdentifier"
    let kHeaderViewCellIdentifier = "HeaderViewCellIdentifier"
    
    let kDataSourceCellTextKey    = "Food_Name";
    let kDataSourceCellPictureKey = "Picture";
    
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
        
        // 增加collectionView
        setupCollectionView()
        
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
    
    /**
     * 增加集合控件
     */
    private func setupCollectionView() {
        
        // 创建collectionView
        let layout      = UICollectionViewFlowLayout()
        collectionView  = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        // 默认为黑色，这里设置为白色以便显示
        collectionView.backgroundColor = UIColor.whiteColor()
        
        // add collectionView
        view.addSubview(collectionView)
        
        // 重用Cell、Header
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        collectionView.registerClass(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewCellIdentifier)
        
        // 设置collection代理为self
        collectionView.dataSource   = self
        collectionView.delegate     = self
    }
    
    // MARK: - UICollectionViewDataSource
    
    /**
     * items count
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource[dataSource.keys.array[section]]!.count
    }
    
    /**
     * cell
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        // 处理数据
        let key   = dataSource.keys.array[indexPath.section]
        let items = dataSource[key]
        let item  = items?[indexPath.row]
        let text  = item?[kDataSourceCellTextKey]
        
        collectionViewCell.button.setTitle(text, forState: UIControlState.Normal)
        
        return collectionViewCell
    }
    
    /**
     * sections count
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return dataSource.count
    }
    
    /**
     * header
     */
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var collectionViewHeader:CollectionViewHeader!
        
        if kind == UICollectionElementKindSectionHeader {
            
            collectionViewHeader = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewCellIdentifier, forIndexPath: indexPath) as! CollectionViewHeader
            collectionViewHeader.titleL.text = dataSource.keys.array[indexPath.section]
            
        }
        
        return collectionViewHeader
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    /**
     * item size
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(100, 30)
    }
    
    /**
     * header edge
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, 16, 10, 16)
    }
    
    /**
     * items 上下之间的最小间距
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 12
    }
    
    /**
     * items 左右之间的最小间距
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 12
    }
    
    /**
     * header size
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSizeMake(CGRectGetWidth(view.bounds) - 32, 38)
    }
}

