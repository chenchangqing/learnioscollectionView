//
//  CollectionViewCell.swift
//  example01
//
//  Created by green on 15/8/20.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var button : UIButton!
    
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
        
//        self.backgroundColor = UIColor.purpleColor()
        button = UIButton(frame: CGRectInset(self.bounds, 0, 0))
        button.generalStyle()
        button.homeStyle()
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(button)
    }
}
