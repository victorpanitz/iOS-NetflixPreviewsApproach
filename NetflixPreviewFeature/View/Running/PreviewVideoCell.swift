//
//  PreviewCustomVideoCell.swift
//  NetflixPreviewFeature
//
//  Created by Victor Magalhaes on 29/04/2018.
//  Copyright © 2018 Victor Magalhaes. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AVKit

class PreviewVideoCell : UICollectionViewCell {
    
    var player = AVPlayer()
    var delegate: PreviewVideoEndedProtocol?
    var trackerDelegate: PreviewVideoTrackingProtocol?
    private var timeObserver: Any?
    private var isObserverSetted = false
        
    var isPlayingVideo = false {
        didSet{
            player.currentTime()
            if isPlayingVideo {
                player.play()
                addObservers()
            } else {
                player.pause()
                removeObservers()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    
    /* ******************************************************* */
    /* *                       SETUP                         * */
    /* ******************************************************* */

    func setupVideoCell(path: String) {
        self.player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = self.bounds        
        self.isPlayingVideo = true
    }
    
    /* ******************************************************* */
    /* *                  OBSERVERS HANDLER                  * */
    /* ******************************************************* */
    
    @objc func playerDidFinishPlaying(){
        self.isPlayingVideo = false
        self.delegate?.handlePreviewWhenVideoEnds(cell: self)
    }
    
    fileprivate func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        let interval = CMTimeMakeWithSeconds(1.0, Int32(NSEC_PER_SEC))
        
        self.timeObserver = self.player.addPeriodicTimeObserver(forInterval: interval, queue: nil) { (time) in
            let progress = Float(self.player.currentTime().seconds / self.player.currentItem!.asset.duration.seconds)
            self.trackerDelegate?.updateVideoProgress(progress)
            if !self.isObserverSetted {
                self.isObserverSetted = true
            }
        }
    }
    
    fileprivate func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        if isObserverSetted {
            self.player.removeTimeObserver(self.timeObserver)
            self.isObserverSetted = false
        }
    }
    
}
