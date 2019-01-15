//
//  SampleHandler.swift
//  siliconmotion
//
//  Created by AlexLu on 2019/1/11.
//  Copyright © 2019 AlexLu. All rights reserved.
//

import ReplayKit

class SampleHandler: RPBroadcastSampleHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        //用户已请求启动广播。可以提供来自UI扩展的设置信息，但这是可选的。
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
        //用户请求暂停广播。样品将停止发货。
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
        //用户已请求恢复广播。样品交付将恢复。
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        //用户已请求完成广播。
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            // Handle video sample buffer
            // 视频样本缓冲器
            break
        case RPSampleBufferType.audioApp:
            // Handle audio sample buffer for app audio
            // 处理app音频样本缓冲区
            break
        case RPSampleBufferType.audioMic:
            // Handle audio sample buffer for mic audio
            // 处理麦克风音频
            break
        }
    }
}
