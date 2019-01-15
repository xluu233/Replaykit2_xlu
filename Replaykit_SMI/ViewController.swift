//
//  ViewController.swift
//  Replaykit_SMI
//
//  Created by AlexLu on 2019/1/11.
//  Copyright © 2019 AlexLu. All rights reserved.
//

import UIKit

import Foundation
import ReplayKit
import AVKit



class ViewController: UIViewController {

    @IBOutlet weak var vedio_first: UIImageView!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var first_image: UIImageView!
    
    var assetWriter:AVAssetWriter!
    var videoInput:AVAssetWriterInput!
    let randomNumber = arc4random_uniform(9999);
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        status.text = "未获取到数据"
        
    }

    @IBAction func start(_ sender: UIButton) {
        
        startRecording(withFileName: "coolScreenRecording\(randomNumber)",recordingHandler: {(error) in
            print("正在录制")
        })
        
        /*
        Recording(withFileName: "coolScreenRecording\(randomNumber)", recordingHandler: { (error) in
            print("Recording in progress")
        }) { (error) in
            print("Recording Complete")
        }*/
    }
    
    
    @IBAction func stop(_ sender: UIButton) {
        stopRecording { (error) in
            print("录制停止")
        }
    }
    
    /*
    func Recording(withFileName fileName: String, recordingHandler: @escaping (Error?) -> Void,onCompletion: @escaping (Error?)->Void)
    {
        startRecording(withFileName: fileName) { (error) in
            recordingHandler(error)
        }
    }*/
    
    

    func startRecording(withFileName fileName: String, recordingHandler:@escaping (Error?)-> Void)
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
            
            
            //func startCapture(handler captureHandler: ((CMSampleBuffer, RPSampleBufferType, Error?) -> Void)?, completionHandler: ((Error?) -> Void)? = nil)
            RPScreenRecorder.shared().startCapture(handler: { (sample, bufferType, error) in
                //                print(sample,bufferType,error)
                
                recordingHandler(error)
                
               // first_image.image = sample
                
                
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
                
            }) { (error) in
                //recordingHandler(error)
                //print("凉凉")
                //debugPrint(error)
            }
        } else
        {
            // Fallback on earlier versions
        }
    }
    
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
        }
    }
    
    @IBAction func get_pic1(_ sender: UIButton) {
        let url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547446450729&di=6d23efe65660547a3c0f9e054ccbd70d&imgtype=0&src=http%3A%2F%2Fimg17.3lian.com%2Fd%2Ffile%2F201702%2F20%2F8d37e5e9d3b046e5804c7ecd9de4d568.jpg")
        let data = try? Data(contentsOf: url!)
        if data != nil {
            let image = UIImage(data: data!)
            vedio_first.image = image
        }
    }
    
    @IBAction func get_pic2(_ sender: UIButton) {
        // 方法一: 同步加载网络图片
        let url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547446450728&di=dbc9a44898d6bb5cc2fc137235d36ca0&imgtype=0&src=http%3A%2F%2Fpic2.ooopic.com%2F13%2F45%2F25%2F15bOOOPIC79_1024.jpg")
        // 从url上获取内容
        // 获取内容结束才进行下一步
        let data = try? Data(contentsOf: url!)
        if data != nil {
            let image = UIImage(data: data!)
            vedio_first.image = image
        }
    }
    
    @IBAction func get_pic3(_ sender: UIButton) {
        let url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547446450728&di=974cc7d9f529f617c85b77f99a661800&imgtype=0&src=http%3A%2F%2Fimg17.3lian.com%2Fd%2Ffile%2F201702%2F07%2F292d891d0ab9d5d6cb62e0227b727ca3.jpg")
        let data = try? Data(contentsOf: url!)
        if data != nil {
            let image = UIImage(data: data!)
            vedio_first.image = image
        }
    }
    
    @IBAction func get_first_image(_ sender: UIButton) {
    }
    
    
    @IBAction func start_broadcast(_ sender: UIButton) {
    }
    
    
    @IBAction func stop_broadcast(_ sender: UIButton) {
    }
    
}

