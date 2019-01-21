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
    
    internal class func filePath(_ fileName: String) -> String
    {
        createReplaysFolder()
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/Replays/\(fileName).mp4"
        
        //获取分组的共享目录
       // let groupURL: NSURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Alex.Replaykit2ForIOS11")! as NSURL
      //  let fileURL: NSURL = groupURL.appendingPathComponent("demo.mp4")! as NSURL
        
        // let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // let documentsDirectory = paths[0] as String
        //let filePath : String = "\(groupURL)/\(fileName).mp4"

        return filePath
    }
    
    internal class func fetchAllReplays() -> Array<URL>
    {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let replayPath = documentsDirectory?.appendingPathComponent("/Replays")
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: replayPath!, includingPropertiesForKeys: nil, options: [])
        return directoryContents
    }
    
}


