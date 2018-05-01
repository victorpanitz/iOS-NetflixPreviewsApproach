//
//  PreviewVideoHeaderView.swift
//  NetflixPreviewFeature
//
//  Created by Victor Magalhaes on 30/04/2018.
//  Copyright © 2018 Victor Magalhaes. All rights reserved.
//

import Foundation
import UIKit

class PreviewVideoHeaderView : UIView {
    
    let videoProgress : UIProgressView = {
        let mProgressView = UIProgressView()
        mProgressView.trackTintColor = UIColor.lightGray
        mProgressView.progressTintColor = UIColor.cyan
        return mProgressView
    }()
    
    let videoLogo: UIImageView = {
        let mImg = UIImageView()
        mImg.contentMode = .scaleAspectFit
//        mImg.backgroundColor = UIColor.orange
        return mImg
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    fileprivate func setupView(){
        
        self.addSubview(videoProgress)
        videoProgress.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(videoLogo)
        videoLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.videoLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.videoLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.videoLogo.heightAnchor.constraint(equalToConstant: self.frame.height * 0.5),
            self.videoLogo.widthAnchor.constraint(equalToConstant: self.frame.width * 0.8),
            
            self.videoProgress.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.videoProgress.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height * 0.2),
            self.videoProgress.heightAnchor.constraint(equalToConstant: self.frame.height * 0.02),
            self.videoProgress.widthAnchor.constraint(equalToConstant: self.frame.width * 0.8),
            
            ])
    }
    
    func deactivateConstraints(){
        NSLayoutConstraint.deactivate([
            self.videoLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.videoLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.videoLogo.heightAnchor.constraint(equalToConstant: self.frame.height * 0.5),
            self.videoLogo.widthAnchor.constraint(equalToConstant: self.frame.width * 0.8),
            
            self.videoProgress.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.videoProgress.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height * 0.2),
            self.videoProgress.heightAnchor.constraint(equalToConstant: self.frame.height * 0.02),
            self.videoProgress.widthAnchor.constraint(equalToConstant: self.frame.width * 0.8)
            
            ])
    }
    
    
}



