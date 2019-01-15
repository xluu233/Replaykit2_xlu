//
//  BroadcastSetupViewController.swift
//  siliconmotionSetupUI
//
//  Created by AlexLu on 2019/1/11.
//  Copyright © 2019 AlexLu. All rights reserved.
//

import ReplayKit

class BroadcastSetupViewController: UIViewController {

    
    // Call this method when the user has finished interacting with the view controller and a broadcast stream can start
    // 当用户完成与视图控制器的交互并可以启动广播流时，调用此方法
    func userDidFinishSetup() {
        // URL of the resource where broadcast can be viewed that will be returned to the application
        // 可以在其中查看广播的资源的URL，该资源将返回给应用程序
        let broadcastURL = URL(string:"http://apple.com/broadcast/streamID")
        
        // Dictionary with setup information that will be provided to broadcast extension when broadcast is started
        // 具有设置信息的Dictionary，这些设置信息将在广播启动时提供给广播扩展
        let setupInfo: [String : NSCoding & NSObjectProtocol] = ["broadcastName": "example" as NSCoding & NSObjectProtocol]
        
        // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
        // 告诉ReplayKit扩展已经完成设置，可以开始播放了
        self.extensionContext?.completeRequest(withBroadcast: broadcastURL!, setupInfo: setupInfo)
        print("userDidfinishsetup")
    }
    
    func userDidCancelSetup() {
        let error = NSError(domain: "YouAppDomain", code: -1, userInfo: nil)
        // Tell ReplayKit that the extension was cancelled by the user
        // 告诉ReplayKit，用户取消了扩展
        self.extensionContext?.cancelRequest(withError: error)
        print("userDidcancelsetup")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidload")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userDidFinishSetup()
        print("viewwillappear")
    }

    
}
