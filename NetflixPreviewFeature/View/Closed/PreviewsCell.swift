//
//  PreviewsCell.swift
//  NetflixPreviewFeature
//
//  Created by Victor Magalhaes on 22/04/2018.
//  Copyright © 2018 Victor Magalhaes. All rights reserved.
//

import Foundation
import UIKit

class PreviewsCell : UITableViewCell {
    
    var collection: UICollectionView? = nil
    var delegate: PreviewItemTouchProtocol?
    
    var previews = [PreviewEntity]()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell() {
                
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let createdCollection: UICollectionView = {
            let mCollection = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
            mCollection.register(PreviewsItemCell.self, forCellWithReuseIdentifier: "mCell")
            mCollection.delegate = self
            mCollection.dataSource = self
            mCollection.isUserInteractionEnabled = true
            mCollection.backgroundColor = UIColor.black
            return mCollection
        }()
        
        collection = createdCollection
        collection?.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.addSubview(collection!)
        collection?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collection!.topAnchor.constraint(equalTo: self.topAnchor),
            self.collection!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.collection!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collection!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
    }

}

extension PreviewsCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.height * 0.7, height: self.frame.height * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mCell", for: indexPath) as! PreviewsItemCell
        cell.setupItem(img: previews[indexPath.row].staticImage ?? "casaPapel")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previews.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mCell", for: indexPath) as! PreviewsItemCell
        
        self.delegate?.previewItemTouched(
            startPos: indexPath.row,
            cell: self,
            collectionOffsetX: collection!.contentOffset.x,
            itemFrame: cell.frame
        )
    }
    
}



