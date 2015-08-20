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
    let kCollectionViewItemButtonImageToTextMargin : CGFloat   = 5  // item 文字和图片的距离
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        // 打印
        // println(NSDictionary(dictionary: dataSource).descriptionWithLocale(nil))
        // println(dataSource.keys.array)
        
        for(var i=0;i<dataSource.keys.array.count;i++) {
            
            var rowsArray = caculateItemsCountForEveryRow(items: arrayForSection(section: i))
            println(rowsArray)
        }
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
        collectionView.backgroundColor = UIColor.whiteColor()
        
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
        let img   = item[kDataSourceCellPictureKey]
        
        // 文字
        collectionViewCell.button.setTitle(text, forState: UIControlState.Normal)
        collectionViewCell.button.setTitle(text, forState: UIControlState.Selected)
        
        // 设置图片
        if img != nil {
            
            collectionViewCell.button.setImage(UIImage(named: "home_btn_shrink"), forState: UIControlState.Normal)
            let spacing = kCollectionViewItemButtonImageToTextMargin
            collectionViewCell.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing)
            collectionViewCell.button.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0)
            
        } else {
            
            collectionViewCell.button.setImage(nil, forState: UIControlState.Normal)
            collectionViewCell.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            collectionViewCell.button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
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
            collectionViewHeader.titleButton.setTitle(dataSource.keys.array[indexPath.section], forState: UIControlState.Normal)
            collectionViewHeader.titleButton.setTitle(dataSource.keys.array[indexPath.section], forState: UIControlState.Selected)
            
        }
        
        return collectionViewHeader
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    /**
     * item size
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let item = dicForItem(indexPath: indexPath)
        let cellWidth = caculateItemWidth(item: item)
        
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
     * @indexPath item单元格数据
     * 
     * @return item的宽度
     */
    private func caculateItemWidth(#item:[String:String]) -> CGFloat {
        
        let text = item[kDataSourceCellTextKey]!
        let img  = item[kDataSourceCellPictureKey]
        
        let size = (text as NSString).sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(16)])
        let limitWidth = CGRectGetWidth(collectionView.frame) - kCollectionViewToLeftMargin - kCollectionViewToRightMargin
        var cellWidth:CGFloat = CGFloat(ceilf(Float(size.width))) + kCellBtnHorizonPadding
        
        // 如果包含图片，增加item的宽度
        if img != nil {
            
            cellWidth += kCellBtnHorizonPadding
        }
        
        // 如果通过文字+图片计算出来的宽度大于等于限制宽度，则改变单元格item的实际宽度
        cellWidth = cellWidth >= limitWidth ? limitWidth : cellWidth
        
        return cellWidth
    }
    
    /**
     * 返回item包括左右边距做需要占据的长度
     *
     * @indexPath item 单元格数据
     * @index item位置
     *
     * @return item的占据的宽度
     */
    private func caculateItemLimitWidth (#item:[String:String],indexAtItems index:Int) -> CGFloat {
        
        let contentViewWidth = CGRectGetWidth(collectionView.frame) - kCollectionViewToLeftMargin - kCollectionViewToRightMargin
        
        // 计算单元格item的实际宽度
        let itemWidth = caculateItemWidth(item: item)
        
        // 单元格item占据的宽度，用于计算该item单元格属于哪一行
        var limitWidth : CGFloat!
        
        // 如果item的实际宽度等于最大限制宽度，那么item占据宽度等于最大限制宽度
        if itemWidth == contentViewWidth {
            
            limitWidth = itemWidth
        } else {
            
            // 如果单元格item是数组中第一个，那么不需要+水平间距
            if index == 0 {
                
                limitWidth = itemWidth
            } else {
                
                let contentViewWidth2 = contentViewWidth - kCollectionViewCellsHorizonPadding
                
                if itemWidth >= contentViewWidth2 {
                    
                    // 如果单元格item不是第一个，而且itemWidth大于最大限制宽度-水平间距，那么item占据宽度为最大限制
                    limitWidth = contentViewWidth
                } else {
                    
                    // 正常占据
                    limitWidth = itemWidth + kCollectionViewCellsHorizonPadding
                }
            }
        }
        return limitWidth
    }
    
    /**
     * 计算指定数组第一行的Item数量
     * 
     * @param items
     *
     * @return 指定数组第一行的Item数量
     */
    private func caculateItemsCountForFirstRow (#items:[[String:String]]) -> Int {
        
        var itemsCount: Int = 0
        let contentViewWidth = CGRectGetWidth(collectionView.frame) - kCollectionViewToLeftMargin - kCollectionViewToRightMargin
        
        let widthArray = NSMutableArray()
        for (var i=0; i<items.count; i++) {
            
            let limitWidth = caculateItemLimitWidth(item: items[i], indexAtItems: i)
            widthArray.addObject(limitWidth)
            
            let sumArray = NSArray(array: widthArray)
            let sum:CGFloat = sumArray.valueForKeyPath("@sum.self") as! CGFloat
            
            if sum <= contentViewWidth {
                
                itemsCount++
            } else {
                break
            }
        }
        
        return itemsCount
    }
    
    /**
     * 返回指定数组每行包行的单元格个数
     * @param items
     * 
     * @return 行数组
     */
    private func caculateItemsCountForEveryRow(var #items:[[String:String]]) -> [Int] {
        
        var resultArray = [Int]()
        let tempArray = NSMutableArray(array: items)
        
        let itemCount = caculateItemsCountForFirstRow(items: items)
        resultArray.append(itemCount)
        
        for item in tempArray {
            
            let itemCount = caculateItemsCountForFirstRow(items: items)
            
            if items.count != itemCount {
                
                items.removeRange(Range(start: 0,end: itemCount))
                
                let itemCount = caculateItemsCountForFirstRow(items: items)
                resultArray.append(itemCount)
            }
        }
        return resultArray
    }
    
    /**
     * 返回每节包含多少行
     */
    private func caculateRowsCountForSection() -> [Int] {
        
        var resultArray = [Int]()
        
        for(var i=0; i<dataSource.count; i++) {
            
            let items = arrayForSection(section: i)
            let rowsCount = caculateItemsCountForEveryRow(items: items).count
            resultArray.append(rowsCount)
        }
        return resultArray
    }
    
    // MARK: -  处理数据
    
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

