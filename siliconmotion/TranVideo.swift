//
//  TranVideo.swift
//  siliconmotion
//
//  Created by AlexLu on 2019/1/25.
//  Copyright © 2019 AlexLu. All rights reserved.
//

import ReplayKit
import UIKit
import Foundation
import AVKit

import AssetsLibrary

public class TranVideo {
    
    
     static var assetWriter:AVAssetWriter!
     static var videoInput:AVAssetWriterInput!
     static let randomNumber = arc4random_uniform(9999);
    
    class func Ready() {
        
        let fileURL = URL(fileURLWithPath: ReplayFileUtil.filePath("coolScreenRecording\(randomNumber)"))
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
        
        print(fileURL)
        print("Ready")
      
    }
    
    public class func start(_ sampleBuffer: CMSampleBuffer){
        
        
        if CMSampleBufferDataIsReady(sampleBuffer)
        {
            if assetWriter.status == AVAssetWriter.Status.unknown
            {
                assetWriter.startWriting()
                assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                print("startWriting")
            }
            
            if assetWriter.status == AVAssetWriter.Status.failed {
                print("Error occured, status = \(assetWriter.status.rawValue), \(assetWriter.error!.localizedDescription) \(String(describing: assetWriter.error))")
                return
            }
            
            if videoInput.isReadyForMoreMediaData
            {
                videoInput.append(sampleBuffer)
                print("appended")
            }
        }
        
        
    }
    
    
    class func stop() {
        assetWriter.finishWriting
            {
                print(ReplayFileUtil.fetchAllReplays())
                print("已停止录制")
        }
    }
    
}
