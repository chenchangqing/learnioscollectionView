//
//  CollectionViewHeader.swift
//  example01
//
//  Created by green on 15/8/20.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {
    
    var titleButton: UIButton!
    var rightButton: UIButton!
    
    let kTitleButtonWidth   :CGFloat = 250
    let kMoreButtonWidth    :CGFloat = 36*2
    let kCureOfLineHight    :CGFloat = 0.5
    let kCureOfLineOffX     :CGFloat = 16
    
    let kHeaderViewHeigt    :CGFloat = 38
    
    // MARK: -
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    // MARK: - SETUP
    
    private func setup() {
        
        // 背景色
        self.backgroundColor = UIColor.grayColor()
        
        // 分割线
        setupLine()
        
        // 标题按钮
        setupTitleButton()
        
        // 右边按钮
        setupRightButton()
    
    }
    
    /**
     * 增加分割线
     */
    private func setupLine() {
        
        // create
        let cureOfLine              = UIView(frame: CGRectMake(kCureOfLineOffX, kHeaderViewHeigt - kCureOfLineHight, CGRectGetWidth(UIScreen.mainScreen().bounds) - 2*kCureOfLineOffX, kCureOfLineHight))
        cureOfLine.backgroundColor  = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1)
        
        // add
        self.addSubview(cureOfLine)
    }
    
    /**
     * 增加左边按钮
     */
    private func setupTitleButton() {
        
        // create
        titleButton = UIButton(frame: CGRectMake(kCureOfLineOffX, 0, kTitleButtonWidth, CGRectGetHeight(self.bounds)))
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0)
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Left
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected)
        
        // add
        self.addSubview(titleButton)
    }
    
    private func setupRightButton() {
        
    }
}
