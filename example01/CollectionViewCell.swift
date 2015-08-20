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
        
        button = UIButton(frame: self.bounds)
        button.generalStyle()
        button.homeStyle()
        contentView.addSubview(button)
    }
}
