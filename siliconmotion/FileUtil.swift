//
//  FileUtil.swift
//  siliconmotion
//
//  Created by AlexLu on 2019/1/17.
//  Copyright © 2019 AlexLu. All rights reserved.
//

import Foundation

class ReplayFileUtil
{
    internal class func createReplaysFolder()
    {
        //func NSSearchPathForDirectoriesInDomains(_ directory: FileManager.SearchPathDirectory, _ domainMask: FileManager.SearchPathDomainMask, _ expandTilde: Bool) -> [String]
        
        // path to documents directory
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let replayDirectoryPath = documentDirectoryPath.appending("/ReplayShare")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: replayDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: replayDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                    print("创建文件夹成功")
                } catch {
                    print("Error creating Replays folder in documents dir: \(error)")
                }
            }
        }
    }
    
    /*
     从 Groups 的共享文件区域获取号码资源
     */
    private func readPhoneSrc(){
        // func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL?
        // forSecurityApplicationGroupIdentifier 的参数是 App Groups 的名称
       // let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")
       // let containerUrl = url?.appendingPathComponent("Library/Caches/dir.plist")
        
       // let exist = FileManager.default.fileExists(atPath: containerUrl!.path)

    }
    

    
    //file:///private/var/mobile/Containers/Data/Application/85CA32DD-3842-4A18-A21F-14F4B7F0F9CD/Documents/Replays/coolScreenRecording8099.mp4
    //file:///private/var/mobile/Containers/Data/PluginKitPlugin/D407DE9F-05E6-4A1B-BFCA-69A65076C9A4/Documents/Replays/coolScreenRecording1765.mp4
    
    //Error occured, status = 3, Cannot Save Optional(Error Domain=AVFoundationErrorDomain Code=-11823 "Cannot Save" UserInfo={NSLocalizedRecoverySuggestion=Try saving again., NSLocalizedDescription=Cannot Save, NSUnderlyingError=0x282b948d0 {Error Domain=NSOSStatusErrorDomain Code=-12412 "(null)"}})
    
    internal class func filePath(_ fileName: String) -> String
    {
        createReplaysFolder()
        
        //获取分组的共享目录
       // let groupURL: NSURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")! as NSURL
       // let fileURL: NSURL = groupURL.appendingPathComponent("demo.txt")! as NSURL
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/ReplayShare/\(fileName).mp4"
       // let filePath : String = "\(fileURL)/\(fileName).mp4"
        
        return filePath
    }
    
    internal class func fetchAllReplays() -> Array<URL>
    {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let replayPath = documentsDirectory?.appendingPathComponent("/ReplayShare")
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: replayPath!, includingPropertiesForKeys: nil, options: [])
        return directoryContents
    }
    
}



