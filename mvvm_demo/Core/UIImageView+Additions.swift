//
//  UIImageView+Additions.swift
//  Pyaterochka
//
//  Created by Igor Vedeneev on 12/29/18.
//  Copyright © 2018 Zeno Inc. All rights reserved.
//

import SDWebImage
import Result
import ReactiveSwift
import ReactiveCocoa

extension UIImageView {
    func setImage(url: URL?,
                  placeholder: UIImage? = nil,
                  size: CGSize? = nil,
                  backgroundColor: UIColor = UIColor.clear,
                  cornerMask: UIRectCorner? = nil,
                  cornerRadius: CGFloat? = nil,
                  takeUntil: Signal<Void, NoError>) {
        
        let contentMode = self.contentMode
        let size_ = size ?? self.bounds.size
        let workItem = DispatchWorkItem { [weak self] in
            guard let `self` = self else { return }
            guard let url = url else {
                let resizedImage = placeholder?.resized(to: size_, backgroundColor: backgroundColor, cornerMask: cornerMask, cornerRadius: cornerRadius)
                DispatchQueue.main.async {
                    self.image = resizedImage
                }
                
                return
            }
            
            let cache = SDImageCache.shared()
            if let img = cache.imageFromCache(forKey: url.absoluteString) {
                let resizedImage = img.resized(to: size_, backgroundColor: backgroundColor, cornerMask: cornerMask, cornerRadius: cornerRadius, contentMode: contentMode)
                DispatchQueue.main.async {
                    self.image = resizedImage
                }
                return
            }
        
            self.reactive.animatableImage <~ ImageDownloader.download(url: url, placeholder: placeholder, size: size_, backgroundColor: backgroundColor, cornerMask: cornerMask, cornerRadius: cornerRadius).observe(on: QueueScheduler.main).take(until: takeUntil)
        }
        
        DispatchQueue.global(qos: .default).async(execute: workItem)
    }
    
    func setAdjustedImage(_ image: UIImage?, size: CGSize) {
        let workItem = DispatchWorkItem { [weak self] in
            let resizedImage = image?.resized(to: size, backgroundColor: Color.white, cornerMask: nil, cornerRadius: nil)
            DispatchQueue.main.async {
                self?.image = resizedImage
            }
        }
        DispatchQueue.global(qos: .default).async(execute: workItem)
    }
    
    var animatableImage: UIImage? {
        set {
            UIView.transition(with: self,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { self.image = newValue },
                              completion: nil)
        }
        get { return self.image }
    }
}

//MARK: - Reactive
extension Reactive where Base: UIImageView {
    var animatableImage: BindingTarget<UIImage?> {
        return makeBindingTarget {(vc, image) in
            vc.animatableImage = image
        }
    }
}

