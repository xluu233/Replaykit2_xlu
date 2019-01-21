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
        
        //测试UserDefaults读取共享数据
        /*
        let defaultForExtension:UserDefaults! = UserDefaults(suiteName: "group.Alex.Replaykit2ForIOS11")
        if(defaultForExtension != nil){
            let result:NSString = defaultForExtension.object(forKey: "year") as! NSString
            print(result)
        }*/
    
        
        //saveWithFile()
    }
    
    func saveWithFile() {
        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString;
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径        l
        let docPath = home.appendingPathComponent("Documents") as NSString;
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("data.plist");
        let dataSource = NSMutableArray();
        dataSource.add("衣带渐宽终不悔");
        dataSource.add("为伊消得人憔悴");
        dataSource.add("故国不堪回首明月中");
        dataSource.add("人生若只如初见");
        dataSource.add("暮然回首，那人却在灯火阑珊处");
        // 4、将数据写入文件中
        dataSource.write(toFile: filePath, atomically: true);
        print(home)
        print(docPath)
        print(filePath);
        //file:///private/var/mobile/Containers/Data/Application/445DFE65-A6BD-43DB-99BC-CFD5A2990F5F/Documents/Replays/coolScreenRecording9378.mp4
        
    }
    
    /*
     file:///private/var/mobile/Containers/Data/PluginKitPlugin/9035A4B2-2841-449D-AC93-B32AEDBAC875/Documents/ReplayShare/coolScreenRecording1190.mp4, file:///private/var/mobile/Containers/Data/PluginKitPlugin/9035A4B2-2841-449D-AC93-B32AEDBAC875/Documents/ReplayShare/coolScreenRecording5148.mp4, file:///private/var/mobile/Containers/Data/PluginKitPlugin/9035A4B2-2841-449D-AC93-B32AEDBAC875/Documents/ReplayShare/coolScreenRecording5227.mp4, file:///private/var/mobile/Containers/Data/PluginKitPlugin/9035A4B2-2841-449D-AC93-B32AEDBAC875/Documents/ReplayShare/coolScreenRecording7368.mp4, file:///private/var/mobile/Containers/Data/PluginKitPlugin/9035A4B2-2841-449D-AC93-B32AEDBAC875/Documents/ReplayShare/coolScreenRecording8452.mp4, file:///private/var/mobile/Containers/Data/PluginKitPlugin/9035A4B2-2841-449D-AC93-B32AEDBAC875/Documents/ReplayShare/coolScreenRecording8557.mp4
     */
    
    
    /*
 [file:///private/var/mobile/Containers/Data/Application/85CA32DD-3842-4A18-A21F-14F4B7F0F9CD/Documents/Replays/coolScreenRecording8099.mp4, file:///private/var/mobile/Containers/Data/Application/85CA32DD-3842-4A18-A21F-14F4B7F0F9CD/Documents/Replays/coolScreenRecording9102.mp4]
 */
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
        
        
        self.assetWriter.finishWriting
        {
            print(ReplayFileUtil.fetchAllReplays())
            print("已停止录制")
        }
    }
    
    
    //样本数据：CMSampleBuffer   样本数据类型：PRSampleBufferType
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            // Handle video sample buffer
            // 视频样本缓冲器
            // 得到YUV数据
            n = n + 1
            print("第", n, "帧")
            
            /*
            startRecording(withFileName: "coolScreenRecording\(randomNumber)", sample: CMSampleBuffer, bufferType:RPSampleBufferType.video,recordingHandler: {(error) in
                print("正在录制")
            })*/
         
            
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
            
            
            //file:///private/var/mobile/Containers/Data/PluginKitPlugin/7ACAB9B7-533E-4213-B914-709E9A607E69/Documents/ReplayShare/coolScreenRecording9300.mp4,
            if CMSampleBufferDataIsReady(sampleBuffer)
            {
                if self.assetWriter.status == AVAssetWriter.Status.unknown
                {
                    self.assetWriter.startWriting()
                    self.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                }
                if self.assetWriter.status == AVAssetWriter.Status.failed {
                    print("Error occured, status = \(self.assetWriter.status.rawValue), \(self.assetWriter.error!.localizedDescription) \(String(describing: self.assetWriter.error))")
                    return
                }
                if self.videoInput.isReadyForMoreMediaData
                {
                    self.videoInput.append(sampleBuffer)
                }
            }
            
            /*
            if self.assetWriter.status == AVAssetWriter.Status.unknown
            {
                print("正在录制")
                self.assetWriter.startWriting()
                self.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
            }
            if self.assetWriter.status == AVAssetWriter.Status.failed {
                print("Error occured, status = \(self.assetWriter.status.rawValue), \(self.assetWriter.error!.localizedDescription) \(String(describing: self.assetWriter.error))")
                return
            }
            
            if self.videoInput.isReadyForMoreMediaData
            {
                self.videoInput.append(sampleBuffer)
            }*/
            
            
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
    
    /*
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
    */
    /*
    func stopRecording(handler: @escaping (Error?) -> Void)
    {
        if #available(iOS 11.0, *)
        {
            RPScreenRecorder.shared().stopCapture
                {    (error) in
                    handler(error)
                    self.assetWriter.finishWriting
                        {
                            print(ReplayFileUtil.fetchAllReplays())
                    }
            }
        } else {
            // Fallback on earlier versions
            //print("存储失败？")
        }
    }*/
    
}
