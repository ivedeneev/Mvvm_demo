//
//  ImageDownloader.swift
//  Pyaterochka
//
//  Created by Igor Vedeneev on 1/26/19.
//  Copyright © 2019 Zeno Inc. All rights reserved.
//

import ReactiveSwift
import SDWebImage
import Result

final class ImageDownloader {
    private static let operationQueue: DispatchQueue = {
        let queue = DispatchQueue(label: "ru.agima.image.download", qos: .default, attributes: .concurrent)
        return queue
    }()
    
    private static var imageScheduer: QueueScheduler = {
        return QueueScheduler(targeting: operationQueue)
    }()
    
    static func download(url: URL,
                         placeholder: UIImage? = nil,
                         size: CGSize,
                         backgroundColor: UIColor = .clear,
                         cornerMask: UIRectCorner? = nil,
                         cornerRadius: CGFloat? = nil) -> SignalProducer<UIImage?, NoError> {
        
        return ImageDownloader.internalDownload(url: url, placeholder: placeholder)
            .map {
                ($0, size, backgroundColor, cornerMask, cornerRadius)
            }
            .observe(on: imageScheduer)
            .flatMap(.latest, redraw)
    }
    
    private static func internalDownload(url: URL, placeholder: UIImage? = nil) -> SignalProducer<UIImage?, NoError> {
        let producer = SignalProducer<UIImage?, NoError> { sink, disposable in
            
            if SDImageCache.shared().imageFromMemoryCache(forKey: url.absoluteString) == nil {
                sink.send(value: placeholder)
            }
            
            let imageDownloadCompletionHandler: SDWebImageDownloaderCompletedBlock = { (image, data, error, finished) in
                guard error == nil, let image = image else {
                    sink.send(value: placeholder)
                    sink.sendCompleted()
                    return
                }
                
                SDImageCache.shared().store(image, forKey: url.absoluteString, toDisk: true, completion: {
                    sink.send(value: image)
                    sink.sendCompleted()
                })
            }
            
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url,
                                                                      options: [ .handleCookies ],
                                                                      progress: nil,
                                                                      completed: imageDownloadCompletionHandler)
        }
        
        return producer
    }
    
    private static func redraw(image: UIImage?,
                               size: CGSize,
                               backgroundColor: UIColor,
                               cornerMask: UIRectCorner? = nil,
                               cornerRadius: CGFloat? = nil) -> SignalProducer<UIImage?, NoError> {
        
        guard let img = image, size != .zero else { return SignalProducer(value: nil) }
        let resizedImg = img.render(with: size, backgroundColor: backgroundColor, cornerMask: cornerMask, cornerRadius: cornerRadius)
        return SignalProducer(value: resizedImg)
    }
}
