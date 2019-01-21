//
//  Buffer_H264.m
//  siliconmotion
//
//  Created by AlexLu on 2019/1/18.
//  Copyright © 2019 AlexLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import <CoreVideo/CVPixelBuffer.h>

@interface
{
    dispatch_queue_t outputQueue;
    dispatch_queue_t encodeQueue;
    VTCompressionSessionRef encodeSession;
    int64_t frameCount;
    BOOL isEncoding;
    NSFileHandle * fileHandle;
}


- (void)writeSps:(NSData*)sps Pps:(NSData*)pps{
    //h264协议 start code
    const uint8_t start[] = {0x00,0x00,0x00,0x01};
    const size_t lenth = 4;
    NSData *header = [NSData dataWithBytes:start length:lenth];
    if (fileHandle) {
        [fileHandle writeData:header];
        [fileHandle writeData:sps];
        [fileHandle writeData:header];
        [fileHandle writeData:pps];
    }
    NSLog(@"文件写入sps pps");
}

- (void)writeEncodeData:(NSData*)data{
    //h264协议 start code
    const uint8_t start[] = {0x00,0x00,0x00,0x01};
    const size_t lenth = 4;
    NSData *header = [NSData dataWithBytes:start length:lenth];
    if (fileHandle) {
        [fileHandle writeData:header];
        [fileHandle writeData:data];
    }
    NSLog(@"文件写入data");
}
