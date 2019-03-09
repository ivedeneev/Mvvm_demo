//
//  СTLabel.swift
//  Marketplace
//
//  Created by Igor Vedeneev on 20.12.17.
//  Copyright © 2017 WeAreLT. All rights reserved.
//

import UIKit
import CoreText
import ReactiveSwift

class LTLabel : UIView {
    var text: TextViewModel? {
        didSet { setNeedsDisplay() }
    }
    private var internalSize: CGSize = .zero
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.textMatrix = .identity
        ctx.translateBy(x: 0, y: bounds.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        text?.drawTextInContext(ctx: ctx)
    }
}



//extension Reactive where Base: LTLabel {
//    var text: BindingTarget<String?> {
//        return makeBindingTarget({ (label, text) in
//            label.text = text
//        })
//    }
//}

