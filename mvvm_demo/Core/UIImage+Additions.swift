//
//  UIImage+Additions.swift
//  Pyaterochka
//
//  Created by Igor Vedeneev on 10/09/2018.
//  Copyright © 2018 Zeno Inc. All rights reserved.
//

import UIKit
import AVFoundation.AVUtilities

extension UIImage {
    func render(with size: CGSize, backgroundColor: UIColor, cornerMask: UIRectCorner? = nil, cornerRadius: CGFloat? = nil) -> UIImage? {
        return resized(to:size, backgroundColor:backgroundColor, cornerMask:cornerMask, cornerRadius:cornerRadius)
    }
    
    /// content modes only center and right
    func resized(to size:CGSize, backgroundColor: UIColor = UIColor.clear, cornerMask: UIRectCorner? = nil, cornerRadius: CGFloat? = nil, contentMode: UIViewContentMode = .center) -> UIImage? {
        guard let cgimage = self.cgImage else { return self }

        let contextImage: UIImage = UIImage(cgImage: cgimage)
        var isOpaque = backgroundColor != UIColor.clear || (cornerRadius ?? 0) == 0
        
        //todo: other content modes
        let origin: CGPoint
        var finalOrigin: CGPoint = .zero
        var sz = self.size
        var resizedSize = size
        switch contentMode {
        case .center:
            origin = .zero
        case .right:
            origin = CGPoint(x: -(self.size.width - size.width), y: 0)
            sz.width -= abs(origin.x)
        case .top:
            origin = CGPoint(x: 0, y: -(self.size.height - size.height))
            sz.height -= origin.y
        case .scaleAspectFit:
            origin = .zero
            sz.height = self.size.height
            sz.width = self.size.width
            resizedSize.height = self.size.height >= self.size.width ? size.height : self.size.height / self.size.width * size.height
            resizedSize.width = self.size.width >= self.size.height ? size.width : self.size.width / self.size.height * size.width
            
            finalOrigin.x = resizedSize.width >= resizedSize.height ? 0 : (size.width - resizedSize.width) / 2.0
            finalOrigin.y = resizedSize.height >= resizedSize.width ? 0 : (size.height - resizedSize.height) / 2.0
            isOpaque = false
            
        default:
            origin = .zero
        }
        let rect = AVMakeRect(aspectRatio: resizedSize, insideRect: CGRect(origin: origin, size: sz))
        let scaledRect = CGRect(x: rect.origin.x * scale,
                                 y: rect.origin.y * scale,
                                 width: rect.size.width * scale,
                                 height: rect.size.height * scale)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: scaledRect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        UIGraphicsBeginImageContextWithOptions(size, isOpaque, UIScreen.main.scale)
        backgroundColor.setFill()
        let context = UIGraphicsGetCurrentContext()
        let finalRect = CGRect(origin: finalOrigin, size: resizedSize)
        context?.fill(finalRect)
        
        if let mask = cornerMask, let radius = cornerRadius {
            let path = UIBezierPath(roundedRect: finalRect, byRoundingCorners: mask, cornerRadii: CGSize(width: radius, height: radius))
            path.addClip()
        }

        cropped.draw(in: finalRect)
        
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized
    }
    
    static func imageWithColor(color: UIColor, size: CGSize, cornerMask: UIRectCorner? = [.allCorners], cornerRadius: CGFloat? = 10) -> UIImage {
        let isOpaque = (cornerRadius ?? 0) == 0
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, UIScreen.main.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        
        if let mask = cornerMask, let radius = cornerRadius {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: mask, cornerRadii: CGSize(width: radius, height: radius))
            path.addClip()
            path.fill()
        } else {
            context?.fill(rect)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
