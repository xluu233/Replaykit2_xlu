//
//  Avplayer.swift
//  Replaykit_SMI
//
//  Created by AlexLu on 2019/1/23.
//  Copyright © 2019 AlexLu. All rights reserved.
//

import Foundation

import UIKit
import AVKit
/// 要创建一个继承自 UIView 的类, 重写它的layerClass方法, 返回 AVPlayerLayer类,
/// 同时说明一下, 显示视频的view , 需要是创建的VideoPlayer类型.
class VideoPlayer: UIView {
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
}

class TestViewController: UIViewController {
    private var avplayer: AVPlayer!
    private var videoView: VideoPlayer! // 显示的视频
    private var playerItem: AVPlayerItem!
    
    ///视频总时长
    var totalTimeFormat: String {
        if let totalTime = self.avplayer.currentItem?.duration {
            let totalTimeSec = CMTimeGetSeconds(totalTime)
            if (totalTimeSec.isNaN) {
                return "00:00"
            }
            return String.init(format: "%02zd:%02zd", Int(totalTimeSec / 60), Int(totalTimeSec.truncatingRemainder(dividingBy: 60.0)))
        }
        
        return "00:00"
    }
    
    ///视频播放时长
    var currentTimeFormat: String {
        if let playTime = self.avplayer.currentItem?.currentTime() {
            let playTimeSec = CMTimeGetSeconds(playTime)
            if (playTimeSec.isNaN) {
                return "00:00"
            }
            return String.init(format: "%02zd:%02zd", Int(playTimeSec / 60), Int(playTimeSec.truncatingRemainder(dividingBy: 60.0)))
        }
        return "00:00"
    }
    
    
    
    // 下面我们开始写方法
    /// 播放
    func play(_ sender: Any) {
        let url = URL(string: "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4")
        let asset = AVURLAsset(url: url!)
        let playerItem = AVPlayerItem(asset: asset)
        self.playerItem = playerItem
        // 监听它状态的改变,实现kvo的方法
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.avplayer = AVPlayer(playerItem: playerItem)
        if let playerLayer = videoView.layer as? AVPlayerLayer {
            playerLayer.player = avplayer
        }
        
        /// 播放结束的通知.
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }
        if keyPath == "status" {
            // 资源准备好, 可以播放
            if playerItem.status == .readyToPlay {
                self.avplayer.play()
            } else {
                print("load error")
            }
        }
    }
    
    // 暂停
    func pause() {
        self.avplayer.pause()
    }
    
    /// 继续
    func resume(_ sender: Any) {
        self.avplayer.play()
    }
    
    /// 播放进度, 可以给我一个 UISlider,
    func progress(_ sender: UISlider) {
        let progress: Float64 = Float64(sender.value)
        if (progress < 0 || progress > 1) {
            return;
        }
        // 1. 当前视频资源的总时长
        if let totalTime = self.avplayer.currentItem?.duration {
            let totalSec = CMTimeGetSeconds(totalTime)
            let playTimeSec = totalSec * progress
            let currentTime = CMTimeMake(value: Int64(playTimeSec), timescale: 1)
            self.avplayer.seek(to: currentTime, completionHandler: { (finished) in
            })
        }
    }
    
    /// 2倍速
    func rate(_ sender: Any) {
        self.avplayer.rate = 2.0
    }
    /// 静音
    func muted() {
        self.avplayer.isMuted = false // true
    }
    
    /// 音量
    func volume(_ sender: UISlider) {
        if (sender.value < 0 || sender.value > 1) {
            return;
        }
        if (sender.value > 0) {
            self.avplayer.isMuted = false
        }
        self.avplayer.volume = sender.value
    }
    
    // 播放完成
    @objc func playToEndTime() {
    }
    deinit {
        playerItem?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
    }
    
}
