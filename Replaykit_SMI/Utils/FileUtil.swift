//
//  FileManager.swift
//  BugReporterTest
//
//  Created by Giridhar on 20/06/17.
//  Copyright © 2017 Giridhar. All rights reserved.
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
            let replayDirectoryPath = documentDirectoryPath.appending("/Replays")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: replayDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: replayDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
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
    
   // var strSavePath : String = self.createProjectDirectoryPath("Large")
    
    internal class func filePath(_ fileName: String) -> String
    {
        createReplaysFolder()
        
        // 读取共享文件夹路径
        //let sharePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")?.path
        //let doc = (sharePath! as NSString).appendingPathComponent("xixi.mp4")
        //print(doc)
        //let filePath2 = "\(doc)/\(fileName).mp4"
     
        
        // 主App文件路径
        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //let documentsDirectory = paths[0] as String
        //print(documentsDirectory)
        //let filePath : String = "\(documentsDirectory)/Replays/\(fileName).mp4"
        
        
        let strSavePath : String =  self.createProjectDirectoryPath(path: "ShareGroup")
        print(strSavePath)
        let filePath3 = "\(strSavePath)/\(fileName).mp4"
        
        return filePath3
    }
    
    /*
    internal class func fetchAllReplays() -> Array<URL>
    {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let replayPath = documentsDirectory?.appendingPathComponent("/Replays")
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: replayPath!, includingPropertiesForKeys: nil, options: [])
        print(directoryContents.count)
        print(directoryContents.last!)
        return directoryContents
    }*/
    
    internal class func fetchAllReplays() -> Array<URL>
    {
        let documentsDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")
        let replayPath = documentsDirectory?.appendingPathComponent("/ShareGroup")
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: replayPath!, includingPropertiesForKeys: nil, options: [])
       // print(directoryContents.count)
        //print(directoryContents.last!)
        return directoryContents
    }
    

}


