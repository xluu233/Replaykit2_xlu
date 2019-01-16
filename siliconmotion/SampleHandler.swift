//
//  SampleHandler.swift
//  siliconmotion
//
//  Created by AlexLu on 2019/1/11.
//  Copyright © 2019 AlexLu. All rights reserved.
//

import ReplayKit

import UIKit
import Foundation
import AVKit

class SampleHandler: RPBroadcastSampleHandler {

    var n = 0
    
    var assetWriter:AVAssetWriter!
    var videoInput:AVAssetWriterInput!
    let randomNumber = arc4random_uniform(9999);
    
    
    
    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        //用户已请求启动广播。可以提供来自UI扩展的设置信息，但这是可选的。
        print("broadcaststarted")
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
        //用户请求暂停广播。样品将停止发货。
        print("broadcastpaused")
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
        //用户已请求恢复广播。样品交付将恢复。
        print("broadcastresumed")
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        //用户已请求完成广播。
        print("broadcastfinished")
    }
    
    
    //样本数据：CMSampleBuffer   样本数据类型：PRSampleBufferType
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            // Handle video sample buffer
            // 视频样本缓冲器
            n = n + 1
            print("第", n, "帧")
            
            /*
            startRecording(withFileName: "coolScreenRecording\(randomNumber)", sample: CMSampleBuffer, bufferType:RPSampleBufferType.video,recordingHandler: {(error) in
                print("正在录制")
            })*/
         

            
            break
        case RPSampleBufferType.audioApp:
            // Handle audio sample buffer for app audio
            // 处理app音频样本缓冲区
            print("APP音频样本")
            break
        case RPSampleBufferType.audioMic:
            // Handle audio sample buffer for mic audio
            // 处理麦克风音频
            print("mic音频样本")
            break
        }
    }
    
    
    func startRecording(withFileName fileName: String, sample:CMSampleBuffer,bufferType: RPSampleBufferType,recordingHandler:@escaping (Error?)-> Void)
    {
        if #available(iOS 11.0, *)
        {
            let fileURL = URL(fileURLWithPath: ReplayFileUtil.filePath(fileName))
            assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType: AVFileType.mp4)
            let videoOutputSettings: Dictionary<String, Any> = [
                AVVideoCodecKey : AVVideoCodecType.h264,
                //AVVideoWidthKey : 1080,
                //AVVideoHeightKey : 1920
                //宽度和高度
                AVVideoWidthKey : UIScreen.main.bounds.size.width,
                AVVideoHeightKey : UIScreen.main.bounds.size.height
            ];
            
            videoInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
            videoInput.expectsMediaDataInRealTime = true
            assetWriter.add(videoInput)
            
            
            if CMSampleBufferDataIsReady(sample)
            {
                if self.assetWriter.status == AVAssetWriter.Status.unknown
                {
                    self.assetWriter.startWriting()
                    self.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sample))
                }
                if self.assetWriter.status == AVAssetWriter.Status.failed {
                    print("Error occured, status = \(self.assetWriter.status.rawValue), \(self.assetWriter.error!.localizedDescription) \(String(describing: self.assetWriter.error))")
                    return
                }
                
                if (bufferType == .video)
                {
                    if self.videoInput.isReadyForMoreMediaData
                    {
                        self.videoInput.append(sample)
                    }
                }
            }
            
    }
    }
    
    
}
