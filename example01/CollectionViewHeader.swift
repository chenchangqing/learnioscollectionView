//
//  CollectionViewHeader.swift
//  example01
//
//  Created by green on 15/8/20.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {
    
    var titleL: UILabel!
    
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
        
        self.backgroundColor = UIColor.grayColor()
        titleL = UILabel(frame: self.bounds)
        self.addSubview(titleL)
    }
}
