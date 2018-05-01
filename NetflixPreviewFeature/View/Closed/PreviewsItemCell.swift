//
//  PreviewsItemCell.swift
//  NetflixPreviewFeature
//
//  Created by Victor Magalhaes on 22/04/2018.
//  Copyright © 2018 Victor Magalhaes. All rights reserved.
//

import Foundation
import UIKit

class PreviewsItemCell : UICollectionViewCell {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupItem (img: String) {
        self.clipsToBounds = true
        let backImg = UIImageView(frame: self.bounds)
        backImg.image = UIImage(named: img)
        backImg.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(backImg)
        self.layer.cornerRadius = self.frame.height / 2
    }
    
}
