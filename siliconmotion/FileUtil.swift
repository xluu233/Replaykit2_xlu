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
    
    internal class func createProjectDirectoryPath(path:String) -> String
    {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")
        let logsPath = containerURL!.appendingPathComponent(path)
        //print(logsPath.path);
        
        do {
            try FileManager.default.createDirectory(at: logsPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        return logsPath.path
        
    }
    

    //file:///private/var/mobile/Containers/Data/Application/85CA32DD-3842-4A18-A21F-14F4B7F0F9CD/Documents/Replays/coolScreenRecording8099.mp4
    //file:///private/var/mobile/Containers/Data/PluginKitPlugin/D407DE9F-05E6-4A1B-BFCA-69A65076C9A4/Documents/Replays/coolScreenRecording1765.mp4
    
   
    internal class func filePath(_ fileName: String) -> String
    {
        createReplaysFolder()
        
        //获取分组的共享目录
       // let groupURL: NSURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")! as NSURL
       // let fileURL: NSURL = groupURL.appendingPathComponent("demo.txt")! as NSURL
        
        // 读取共享文件夹路径
        //let sharePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")?.path
        //let filePath2 = (sharePath! as NSString).appendingPathComponent("\(fileName).mp4")
        //print(filePath2)
        
        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //let documentsDirectory = paths[0] as String
        //let filePath : String = "\(documentsDirectory)/ReplayShare/\(fileName).mp4"
        //print(filePath)
       // let filePath : String = "\(fileURL)/\(fileName).mp4"
        
        let strSavePath : String =  self.createProjectDirectoryPath(path: "ShareGroup")
        let filePath3 = "\(strSavePath)/\(fileName).mp4"
        print(filePath3)
        
        return filePath3
    }
    
    /*
    internal class func fetchAllReplays() -> Array<URL>
    {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let replayPath = documentsDirectory?.appendingPathComponent("/ReplayShare")
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: replayPath!, includingPropertiesForKeys: nil, options: [])
        return directoryContents
    }*/
    
    internal class func fetchAllReplays() -> Array<URL>
    {
        let documentsDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")
        let replayPath = documentsDirectory?.appendingPathComponent("/ShareGroup")
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: replayPath!, includingPropertiesForKeys: nil, options: [])
        print(directoryContents.count)
        print(directoryContents)
        return directoryContents
    }
    
}



