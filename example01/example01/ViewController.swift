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
    
    let kCellIdentifier           = "CellIdentifier"                // 重用单元格ID
    let kHeaderViewCellIdentifier = "HeaderViewCellIdentifier"      // 重用标题ID
    
    let kDataSourceCellTextKey    = "Food_Name";                    // json key1
    let kDataSourceCellPictureKey = "Picture";                      // json key2
    
    // collectionView的 左、上、右、下 边距
    let kCollectionViewToLeftMargin         : CGFloat          = 16
    let kCollectionViewToTopMargin          : CGFloat          = 12
    let kCollectionViewToRightMargin        : CGFloat          = 16
    let kCollectionViewToBottomtMargin      : CGFloat          = 10
    
    let kCollectionViewCellsHorizonPadding  : CGFloat          = 12 // items 之间的水平间距padding
    let kCollectionViewCellHeight           : CGFloat          = 30 // item height
    
    let kCellBtnHorizonPadding              : CGFloat          = 16 // item 中按钮padding
    
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
        let layout      = UICollectionViewLeftAlignedLayout()
        collectionView  = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        // 默认为黑色，这里设置为白色以便显示
        collectionView.backgroundColor = UIColor.magentaColor()
        
        // 内容下移20，为了不遮挡状态栏
        collectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
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
        let item  = dicForItem(indexPath: indexPath)
        let text  = item[kDataSourceCellTextKey]
        
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
        
        let item = dicForItem(indexPath: indexPath)
        let text = item[kDataSourceCellTextKey]!
        let cellWidth = caculateItemWidth(text: text)
        
        return CGSizeMake(cellWidth, kCollectionViewCellHeight)
    }
    
    /**
     * header edge
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(kCollectionViewToTopMargin, kCollectionViewToLeftMargin, kCollectionViewToBottomtMargin, kCollectionViewToRightMargin)
    }
    
    /**
     * items 左右之间的最小间距
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return kCollectionViewCellsHorizonPadding
    }
    
    /**
     * header size
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSizeMake(CGRectGetWidth(view.bounds) - 50, 38)
    }
    
    // MARK: - caculate
    
    /**
     * 返回item的width
     *
     * @param text 文字
     * 
     * @return item的宽度
     */
    private func caculateItemWidth(#text:String) -> CGFloat {
        
        let size = (text as NSString).sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(16)])
        let cellWidth = ceilf(Float(size.width))
        return CGFloat(cellWidth) + kCellBtnHorizonPadding
    }
    
    /**
     * 返回节对应的数组
     */
    private func arrayForSection(#section:Int) -> [[String:String]] {
        
        // 处理数据
        let key   = dataSource.keys.array[section]
        let items = dataSource[key]!
        return items
    }
    
    /**
     * 返回item数据
     */
    private func dicForItem(#indexPath:NSIndexPath) -> [String:String] {
        
        let items = arrayForSection(section: indexPath.section)
        let item  = items[indexPath.row]
        
        return item
    }
}

