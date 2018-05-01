//
//  PreviewCustomView.swift
//  NetflixPreviewFeature
//
//  Created by Victor Magalhaes on 22/04/2018.
//  Copyright © 2018 Victor Magalhaes. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PreviewCustomView: UIView {
    
    var isShowing = true
    var backImg = UIImageView()
    var previews = [PreviewEntity]()
    var firstRun = true
    var startPos = 0
    var currentPos = 0
    var rotationAngle: CGFloat!

    let blurEffectView : UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let mBlur = UIVisualEffectView(effect: blurEffect)
        mBlur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return mBlur
    }()
    
    let videoHeaderPV: UIPickerView = {
        let mPickerView = UIPickerView()
        return mPickerView
    }()
    
    var previewCollectionView: UICollectionView? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ startPos: Int, _ previews: [PreviewEntity], _ collectionOffsetX: CGFloat, _ tableOffsetY: CGFloat, _ itemFrame: CGRect, _ tableCellOrigin: CGPoint) {
        super.init(frame: .zero)
        self.previews = previews
        self.startPos = startPos
        let frame = CGRect(
            x: itemFrame.origin.x - collectionOffsetX,
            y: itemFrame.origin.y + tableCellOrigin.y - tableOffsetY ,
            width: itemFrame.width,
            height: itemFrame.height)
        videoHeaderBaseSetup()
        setupExpandableView(frame: frame)
    }
    
    fileprivate func videoHeaderBaseSetup(){
        self.videoHeaderPV.delegate = self
        self.videoHeaderPV.dataSource = self
        self.rotationAngle = -90 * (.pi/180)
        self.videoHeaderPV.transform = CGAffineTransform(rotationAngle: rotationAngle)
        self.videoHeaderPV.isUserInteractionEnabled = false

    }
    
    fileprivate func setupExpandableView(frame: CGRect){
        self.frame = frame
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        backImg = UIImageView(frame: self.bounds)
        backImg.image = UIImage(named: previews[startPos].staticImage ?? "casaPapel")
        backImg.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(backImg)
    }
    
    
    /* ******************************************************* */
    /* *                EXHIBITION CONTROL                   * */
    /* ******************************************************* */
    
    func showPreview(){
        UIApplication.shared.isStatusBarHidden = true
        let mainView = self.superview!
        let viewH = mainView.frame.height
        let viewW = mainView.frame.width
        blurEffectView.alpha = 0.8
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX:  1.5, y:  1.5)
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveLinear, animations: {
                self.transform = CGAffineTransform.identity
                self.frame = CGRect(x: 0, y: 0, width: viewW, height: viewH)
                self.layer.cornerRadius = ((viewH * viewW) / (viewH + viewW)) / 2
                self.backImg.frame = self.frame
            }, completion: {(_) in
                UIView.animate(withDuration: 0.15, animations: {
                    self.layer.cornerRadius = 0
                }, completion: { (_) in
                    self.frame = CGRect(x: 0, y:  0, width: viewW, height: viewH)
                    self.backImg.frame = self.frame
                    self.backImg.removeFromSuperview()
                    self.blurEffectView.removeFromSuperview()
                    self.setupPreviewCollection()
                    self.setupVideoHeader()
                    self.isShowing = true
                })
            })
        }
    }
    
    func dismissPreview(){
        UIApplication.shared.isStatusBarHidden = false
        (self.previewCollectionView?.cellForItem(at: IndexPath(row: self.currentPos, section: 0)) as! PreviewVideoCell).isPlayingVideo = false
        let viewH = self.superview!.frame.height
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0
            self.frame = CGRect(x: self.frame.origin.x,y: viewH * 2,width: self.frame.width,height: self.frame.height)
        }, completion: {(_) in
            self.previewCollectionView!.removeFromSuperview()
            for i in 0..<self.previews.count {
                if self.videoHeaderPV.view(forRow: i, forComponent: 0) as? PreviewVideoHeaderView != nil {
                    let view = self.videoHeaderPV.view(forRow: i, forComponent: 0) as! PreviewVideoHeaderView
                    view.deactivateConstraints()
                }
            }
            self.isShowing = false
            self.removeFromSuperview()
        })
    }
    
    /* ******************************************************* */
    /* *                SETUP VIDEO AND HEADER               * */
    /* ******************************************************* */
    
    fileprivate func setupVideoHeader(){
        self.videoHeaderPV.frame = CGRect(
            x: 0,
            y: self.superview!.safeAreaInsets.top,
            width: self.frame.width,
            height: self.frame.height * 0.15
        )
        self.addSubview(self.videoHeaderPV)
    }
    
    fileprivate func setupPreviewCollection(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let createdCollection: UICollectionView = {
            let mCollection = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
            mCollection.register(PreviewVideoCell.self, forCellWithReuseIdentifier: "cell")
            mCollection.delegate = self
            mCollection.dataSource = self
            mCollection.isPagingEnabled = true
            mCollection.isScrollEnabled = true
            return mCollection
        }()
        
        previewCollectionView = createdCollection
        let indexToScroll = IndexPath(row: self.startPos, section: 0)
        self.previewCollectionView?.scrollToItem(at: indexToScroll, at: .left, animated: false)
        self.addSubview(previewCollectionView!)
        self.bringSubview(toFront: previewCollectionView!)
    }
}

    /* ******************************************************* */
    /* *      VIDEO PLAYER COLLECTION EXTENSION HANDLER      * */
    /* ******************************************************* */

extension PreviewCustomView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PreviewVideoCell
        cell.delegate = self
        cell.trackerDelegate = self
        cell.setupVideoCell(path: self.previews[indexPath.row].previewVideoUrl!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {        
        if firstRun {
            self.currentPos = self.startPos
            self.firstRun = false
        }else{
            self.currentPos = indexPath.row
        }
        
        if (collectionView.cellForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section)) as? PreviewVideoCell) != nil {
            let cell = (collectionView.cellForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section)) as? PreviewVideoCell)
            cell?.isPlayingVideo = false
        }
        
        if (collectionView.cellForItem(at: IndexPath(item: indexPath.item + 1, section: indexPath.section)) as? PreviewVideoCell) != nil {
            let cell = (collectionView.cellForItem(at: IndexPath(item: indexPath.item + 1, section: indexPath.section)) as? PreviewVideoCell)
            cell?.isPlayingVideo = false
        }
    
        self.videoHeaderPV.selectRow(indexPath.item, inComponent: 0, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previews.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = (collectionView.cellForItem(at: indexPath) as! PreviewVideoCell)
        cell.isPlayingVideo = !cell.isPlayingVideo
    }
    
}

    /* ******************************************************* */
    /* *           VIDEO HEADER PV EXTENSION HANDLER         * */
    /* ******************************************************* */

extension PreviewCustomView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.previews.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.frame.width / 3
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.frame.height * 0.15
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view = PreviewVideoHeaderView(frame: CGRect(
                        x: 0,
                        y: 0,
                        width: self.frame.height * 0.15,
                        height: self.frame.width / 3)
                    )
        view.videoLogo.image = UIImage(named: previews[row].logoHeader!)
        view.transform = CGAffineTransform(rotationAngle: -rotationAngle)
        return view
    }
}

    /* ******************************************************* */
    /* *             PROTOCOLS EXTENSION HANDLER             * */
    /* ******************************************************* */

extension PreviewCustomView: PreviewVideoEndedProtocol, PreviewVideoTrackingProtocol{
    func updateVideoProgress(_ progress: Float){
        let currentHeader = self.videoHeaderPV.view(forRow: currentPos, forComponent: 0) as! PreviewVideoHeaderView
        currentHeader.videoProgress.setProgress(progress, animated: true)
    }
    
    func handlePreviewWhenVideoEnds(cell: PreviewVideoCell) {
        self.previewCollectionView!.isScrollEnabled = true
        cell.player.seek(to: kCMTimeZero)
        let currentIndex = self.previewCollectionView?.indexPath(for: cell)
        if currentIndex!.item < (self.previews.count - 1) {
            let nextIndex = IndexPath(item: currentIndex!.item + 1, section: currentIndex!.section)
            self.previewCollectionView?.scrollToItem(at: nextIndex, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
//            self.previewCollectionView!.isScrollEnabled = false
            
        }else{
//            self.previewCollectionView!.isScrollEnabled = false
            self.dismissPreview()
        }
    }
}


