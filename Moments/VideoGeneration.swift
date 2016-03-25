//
//  VideoGeneration.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AssetsLibrary
import MediaPlayer
import CoreMedia

class VideoGeneration {
    static func videoGeneration(fav: Bool, start: NSDate, end: NSDate){
        let (image, vid) = getImagesAndVideos(start, end: end, fav: fav)
        print(image.count)
        ImagesToVideo.create()
        print(vid.count)
    }
    
    static func getImagesAndVideos(start : NSDate, end : NSDate, fav: Bool) ->(images: [UIImage], videos: [NSURL!]){
        let momentsMO = CoreDataFetchHelper.fetchDateRangeMomentsMOFromCoreData(start, end: end)
        var imageList = [UIImage]()
        var videoList = [NSURL!]()
        for moment in momentsMO {
            if (!fav || (fav && moment.getFavourite())){
                for i in moment.containedImageItem! {
                    let ci = i as! ImageItem
                    imageList.append(ci.getImage()!);
                }
                for v in moment.containedVideoItem! {
                    videoList.append(v.url())
                }
            }
        }
        print(momentsMO.count)
        return (imageList, videoList)
    }
    
    
    func combineVideo(firstAsset : AVAsset?, secondAsset : AVAsset?, audioAsset : AVAsset?){
        // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()
        
        // 2 - Create two video tracks
        let firstTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            try firstTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, firstAsset!.duration),
                ofTrack: firstAsset!.tracksWithMediaType(AVMediaTypeVideo)[0] ,
                atTime: kCMTimeZero)
        } catch _ {
        }
        
        let secondTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            try secondTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, secondAsset!.duration),
                ofTrack: secondAsset!.tracksWithMediaType(AVMediaTypeVideo)[0] ,
                atTime: firstAsset!.duration)
        } catch _ {
        }
        
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset!.duration, secondAsset!.duration))
        
        let firstInstruction = videoCompositionInstructionForTrack(firstTrack, asset: firstAsset!)
        firstInstruction.setOpacity(0.0, atTime: firstAsset!.duration)
        let secondInstruction = videoCompositionInstructionForTrack(secondTrack, asset: secondAsset!)
        
        mainInstruction.layerInstructions = [firstInstruction, secondInstruction]
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(1, 30)
        mainComposition.renderSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        
        // 3 - Audio track
        if let loadedAudioAsset = audioAsset {
            let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: 0)
            do {
                try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset!.duration, secondAsset!.duration)),
                    ofTrack: loadedAudioAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                    atTime: kCMTimeZero)
            } catch _ {
            }
        }
        
        // 4 - Get path
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        let date = dateFormatter.stringFromDate(NSDate())
        let savePath = (documentDirectory as NSString).stringByAppendingPathComponent("mergeVideo-\(date).mov")
        let url = NSURL(fileURLWithPath: savePath)
        
        // 5 - Create Exporter
        let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        exporter!.outputURL = url
        exporter!.outputFileType = AVFileTypeQuickTimeMovie
        exporter!.shouldOptimizeForNetworkUse = true
        exporter!.videoComposition = mainComposition
        
        // 6 - Perform the Export
        exporter!.exportAsynchronouslyWithCompletionHandler({
            switch exporter!.status{
            case  AVAssetExportSessionStatus.Failed:
                print("failed \(exporter!.error)")
            case AVAssetExportSessionStatus.Cancelled:
                print("cancelled \(exporter!.error)")
            default:
                print("complete")
            }
        })
    }
    
    
    func videoCompositionInstructionForTrack(track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracksWithMediaType(AVMediaTypeVideo)[0]
        
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform)
        
        var scaleToFitRatio = UIScreen.mainScreen().bounds.width / assetTrack.naturalSize.width
        if assetInfo.isPortrait {
            scaleToFitRatio = UIScreen.mainScreen().bounds.width / assetTrack.naturalSize.height
            let scaleFactor = CGAffineTransformMakeScale(scaleToFitRatio, scaleToFitRatio)
            instruction.setTransform(CGAffineTransformConcat(assetTrack.preferredTransform, scaleFactor),
                atTime: kCMTimeZero)
        } else {
            let scaleFactor = CGAffineTransformMakeScale(scaleToFitRatio, scaleToFitRatio)
            var concat = CGAffineTransformConcat(CGAffineTransformConcat(assetTrack.preferredTransform, scaleFactor), CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.width / 2))
            if assetInfo.orientation == .Down {
                let fixUpsideDown = CGAffineTransformMakeRotation(CGFloat(M_PI))
                let windowBounds = UIScreen.mainScreen().bounds
                let yFix = assetTrack.naturalSize.height + windowBounds.height
                let centerFix = CGAffineTransformMakeTranslation(assetTrack.naturalSize.width, yFix)
                concat = CGAffineTransformConcat(CGAffineTransformConcat(fixUpsideDown, centerFix), scaleFactor)
            }
            instruction.setTransform(concat, atTime: kCMTimeZero)
        }
        
        return instruction
    }
    
    func orientationFromTransform(transform: CGAffineTransform) -> (orientation: UIImageOrientation, isPortrait: Bool) {
        var assetOrientation = UIImageOrientation.Up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .Right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .Left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .Up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .Down
        }
        return (assetOrientation, isPortrait)
    }
}