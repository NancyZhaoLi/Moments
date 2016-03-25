//
//  ImagesToVideo.swift
//  Moments
//
//  Created by Nancy Li on 2016-03-21.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ImagesToVideo {
    static func create(image: [UIImage]){
    
        let fileURL = NSURL(fileURLWithPath: "/Users/nancyli/Programming/m.mp4")
        var videoWriter: AVAssetWriter?
        print(image[0].size.height,image[0].size.width)
        let inputSize = CGSize(width: 746, height: 746)
        let outputSize = CGSize(width: 746, height: 746)
        
        do {
            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
        } catch {}
    
        do {
            try videoWriter = AVAssetWriter(URL: fileURL, fileType: AVFileTypeMPEG4)
        } catch let writerError as NSError {
            print("error")
            videoWriter = nil
        }
        
        if let videoWriter = videoWriter{
            let videoSettings: [String : AnyObject] = [
                AVVideoCodecKey  : AVVideoCodecH264,
                AVVideoWidthKey  : outputSize.width,
                AVVideoHeightKey : outputSize.height
            ]
            
            let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoSettings)
            
            let sourceBufferAttributes = [String : AnyObject](dictionaryLiteral:
                (kCVPixelBufferPixelFormatTypeKey as String, Int(kCVPixelFormatType_32ARGB)),
                (kCVPixelBufferWidthKey as String, Float(inputSize.width)),
                (kCVPixelBufferHeightKey as String, Float(inputSize.height))
            )
            
            let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
                assetWriterInput: videoWriterInput,
                sourcePixelBufferAttributes: sourceBufferAttributes
            )
            
            assert(videoWriter.canAddInput(videoWriterInput))
            videoWriter.addInput(videoWriterInput)
            
            if videoWriter.startWriting() {
                videoWriter.startSessionAtSourceTime(kCMTimeZero)
                assert(pixelBufferAdaptor.pixelBufferPool != nil)
                
                let media_queue = dispatch_queue_create("mediaInputQueue", nil)
                
                videoWriterInput.requestMediaDataWhenReadyOnQueue(media_queue, usingBlock: { () -> Void in
                    let fps: Int32 = 1
                    let frameDuration = CMTimeMake(1, fps)
                    
                    var frameCount: Int64 = 0
                    var remainingPhotoURLs = [UIImage](image)
                    
                    while (videoWriterInput.readyForMoreMediaData && !remainingPhotoURLs.isEmpty) {
                        print("Remain %d",remainingPhotoURLs.count)
                        let nextPhotoURL = remainingPhotoURLs.removeAtIndex(0)
                        let lastFrameTime = CMTimeMake(frameCount, fps)
                        let presentationTime = frameCount == 0 ? lastFrameTime : CMTimeAdd(lastFrameTime, frameDuration)
                        if (!appendPixelBufferForImageAtURL(nextPhotoURL, pixelBufferAdaptor: pixelBufferAdaptor, presentationTime: presentationTime)){
                            break
                        }

                        frameCount++
                    }

                    videoWriterInput.markAsFinished()
                    videoWriter.finishWritingWithCompletionHandler {()}
                })
            }
        }
    }

    static func appendPixelBufferForImageAtURL(image: UIImage, pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor, presentationTime: CMTime) -> Bool {
        var appendSucceeded = false
        
        autoreleasepool {
            if let pixelBufferPool = pixelBufferAdaptor.pixelBufferPool {
                    let pixelBufferPointer = UnsafeMutablePointer<CVPixelBuffer?>.alloc(1)
                    let status: CVReturn = CVPixelBufferPoolCreatePixelBuffer(
                        kCFAllocatorDefault,
                        pixelBufferPool,
                        pixelBufferPointer
                    )
                    
                    if let pixelBuffer = pixelBufferPointer.memory where status == 0 {
                        fillPixelBufferFromImage(image, pixelBuffer: pixelBuffer)
                        
                        appendSucceeded = pixelBufferAdaptor.appendPixelBuffer(
                            pixelBuffer,
                            withPresentationTime: presentationTime
                        )
                        
                        pixelBufferPointer.destroy()
                    } else {
                        NSLog("error: Failed to allocate pixel buffer from pool")
                    }
                    
                    pixelBufferPointer.dealloc(1)
            }
        }
        
        return appendSucceeded
    }
    
    static func fillPixelBufferFromImage(image: UIImage, pixelBuffer: CVPixelBufferRef) {
        CVPixelBufferLockBaseAddress(pixelBuffer, 0)
        
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGBitmapContextCreate(
            pixelData,
            Int(image.size.width),
            Int(image.size.height),
            8,
            CVPixelBufferGetBytesPerRow(pixelBuffer),
            rgbColorSpace,
            CGImageAlphaInfo.PremultipliedFirst.rawValue
        )
        
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage)
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0)
    }
}