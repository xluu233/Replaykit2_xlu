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
        
      //  saveWithFile()
        

        
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
    
    func saveWithFile() {
        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString;
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径        l
        let docPath = home.appendingPathComponent("Documents") as NSString;
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("data.txt");
       // let filePath = "/var/mobile/Containers/Data/Application/445DFE65-A6BD-43DB-99BC-CFD5A2990F5F/Documents/data.plist";
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
    
    
    @IBAction func stop(_ sender: UIButton) {
        stopRecording { (error) in
            print("录制停止")
        }
    }
    


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
                        print("startWriting")
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
                            print("appended")
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
    

    @IBAction func save_image(_ sender: UIButton) {
       // UIImageWriteToSavedPhotosAlbum(vedio_first, self, "image:didFinishSavingWithError:contextInfo:", nil)
        //saveBtnClick()
        
        /*
        let shareDefault = UserDefaults(suiteName: "group.Alex.Replaykit2ForIOS11")
        shareDefault?.synchronize()
        status.text = shareDefault?.string(forKey: "group")*/
        
        //1 读取共享文件夹
        let sharePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")?.path
        //2 拼接路径
        let filePath = (sharePath! as NSString).appendingPathComponent("coolScreenRecording1765.mp4")
        //3 复制
        //vedio_first.setImageData(NSData(contentsOfFile: filePath))
    
        let data = try? Data(NSData(contentsOfFile: filePath) as Data)
        if data != nil {
            print("获取到数据")
            //let image = UIImage(data: data!)
            //vedio_first.image = image
        }
        
    }
    
    //NSData * UIImageJPEGRepresentation(UIImage *image, CGFloat compressionQuality);
    //func jpegData(compressionQuality: CGFloat) -> Data?
    
    //将view转成图片并保存相册
    @objc func saveBtnClick(){
        let frame = vedio_first.frame
        UIGraphicsBeginImageContext(frame.size)
        vedio_first.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.loadImage(image: image!)
    }
    
    //保存图片
    func loadImage(image:UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        if didFinishSavingWithError != nil
        {
            print("error!")
            return
        }
        
        print("保存成功")
    }
    
    
    @IBAction func play_video(_ sender: UIButton) {
        
        //读取本地路径
        /*
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/Replays/coolScreenRecording7742.mp4"
        print(filePath)*/
        
        
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")
        let logsPath = containerURL!.appendingPathComponent("ShareGroup")
       // print(logsPath.path);
       // let filePath : String = "\(logsPath.path)/coolScreenRecording\(randomNumber).mp4"
        let filePath : String = "\(logsPath.path)/coolScreenRecording8001.mp4"
        print(filePath)
        

        ///private/var/mobile/Containers/Shared/AppGroup/0066FD3B-8028-4B96-8E9A-5E17B13EFE98/ShareGroup/coolScreenRecording770.mp4
        // file:///private/var/mobile/Containers/Shared/AppGroup/0066FD3B-8028-4B96-8E9A-5E17B13EFE98/ShareGroup/coolScreenRecording770.mp4
        //coolScreenRecording2813
        
        //定义一个视频文件路径
       //let filePath = Bundle.main.path(forResource: "video4", ofType: "mp4")
       // print(filePath!)
        let videoURL = URL(fileURLWithPath: filePath)
        //定义一个视频播放器，通过本地文件路径初始化
        let player = AVPlayer(url: videoURL)
        //设置大小和位置（全屏）
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        //添加到界面上
        self.view.layer.addSublayer(playerLayer)
        //开始播放
        player.play()
        
        
        /*
         //遍历本地视频目录
         let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
         let replayPath = documentsDirectory?.appendingPathComponent("/Replays")
         let directoryContents = try! FileManager.default.contentsOfDirectory(at: replayPath!, includingPropertiesForKeys: nil, options: [])
         print(directoryContents)
         */
        
        /*
         //播放网络视频
         let playerView = CAplayerView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 250), theUrl: URL(string: "https://ksv-video-publish.cdn.bcebos.com/08df4e2d4693fd903134cd307f1df9db354d14e2.mp4?auth_key=1550653931-0-0-2d5ca04bdd8d935882ecb66fdaa42157")!)
         playerView.backgroundColor = UIColor.black
         self.view.addSubview(playerView)*/
    }
    
    
}

