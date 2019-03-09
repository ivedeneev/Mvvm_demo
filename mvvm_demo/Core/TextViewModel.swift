//
//  TextViewModel.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/5/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import UIKit


final class TextViewModel {
    let attributedText: NSAttributedString
    let size: CGSize
    let lines : Array<LineLayoutData>
    
    convenience init(text: String, style: TextStyleProtocol, maxWidth: CGFloat, numberOfLines: Int = 0) {
        self.init(text: NSAttributedString(string: text, style: style), maxWidth: maxWidth, numberOfLines: numberOfLines)
    }
    
    init(text: NSAttributedString, maxWidth: CGFloat, numberOfLines: Int = 0) {
        let stringRef = text as CFAttributedString
        let alignment = text.string.isEmpty ? .left : (text.attribute(NSAttributedStringKey.paragraphStyle, at: 0, effectiveRange: nil) as! NSParagraphStyle).alignment
        let typeSetter = CTTypesetterCreateWithAttributedString(stringRef)
        
        var lines: Array<LineLayoutData> = []
        
        var startIdx: CFIndex = 0
        var lineIdx: CFIndex = 0
        
        let len: CFIndex = CFAttributedStringGetLength(stringRef)
        
        var size = CGSize.zero
        
        while (startIdx < len && (numberOfLines == 0 || lineIdx < numberOfLines)) {
            let lineCharactersCount: CFIndex = CTTypesetterSuggestLineBreak(typeSetter, startIdx, Double(maxWidth))
            let line: CTLine
            let endIdx: CFIndex = startIdx + lineCharactersCount - 1
            let lastLineReached = numberOfLines > 0 && lineIdx + 1 == numberOfLines
            let hasMoreText = endIdx + 1 < len
            let needsTruncation = lastLineReached && hasMoreText && text.string[text.string.index(text.string.startIndex, offsetBy: endIdx)] != "\n"
            if needsTruncation {
                let extraCharactersCount: CFIndex = 20
                let largerLineLength = min(extraCharactersCount, len-(startIdx+lineCharactersCount))
                let largerLine = CTTypesetterCreateLine(typeSetter, CFRangeMake(startIdx, lineCharactersCount+largerLineLength))
                let attributes = CFAttributedStringGetAttributes(stringRef, endIdx, nil)
                let dotsString: CFString = "..." as CFString
                let truncationTokenString = CFAttributedStringCreate(kCFAllocatorDefault, dotsString, attributes)
                let truncationToken = CTLineCreateWithAttributedString(truncationTokenString!)
                let truncatedLine = CTLineCreateTruncatedLine(largerLine, Double(maxWidth), .end, truncationToken)
                line = truncatedLine!
            } else {
                line = CTTypesetterCreateLine(typeSetter, CFRangeMake(startIdx, lineCharactersCount))
            }
            
            var ascent: CGFloat = 0
            var descent: CGFloat = 0
            var leading: CGFloat = 0
            let lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
            
            size.width = max(size.width, CGFloat(lineWidth), maxWidth)
            if lineIdx == 0 {
                size.height += ascent + leading
            } else {
                size.height += ascent + descent + leading
            }
            
            let originX: CGFloat
            
            switch alignment {
            case .left:
                originX = 0
                break
            case .center:
                originX = max(0, (maxWidth - CGFloat(lineWidth)) / 2)
                break
            case .right:
                originX = maxWidth - CGFloat(lineWidth)
                break
            default:
                originX = 0
            }
            
            let point: CGPoint = CGPoint(x:originX, y:size.height-descent-leading)
            let renderedLine = LineLayoutData(line:line, origin:point)
            lines.append(renderedLine)
            
            startIdx+=lineCharactersCount
            lineIdx += 1
        }
        
        size.width.round(.up)
        size.height.round(.up)
        self.lines = lines
        self.size = size
        self.attributedText = text
    }
    
    func drawTextInContext(ctx:CGContext) {
        for line in lines {
            var origin = line.origin
            origin.y = self.size.height - origin.y
            ctx.textPosition = origin
            CTLineDraw(line.line, ctx)
        }
    }
}

struct LineLayoutData : Hashable {
    static func ==(lhs: LineLayoutData, rhs: LineLayoutData) -> Bool {
        return lhs.line == rhs.line
    }
    
    var line: CTLine
    var origin: CGPoint
    var hashValue: Int {
        return line.hashValue
    }
    
    init(line: CTLine, origin: CGPoint) {
        self.line = line
        self.origin = origin
    }
}
