//
//  AnimationView.swift
//  UIBezierPathFromString
//
//  Created by Johnny Wang on 2018/6/8.
//  Copyright © 2018年 Johnny Wang. All rights reserved.
//

import UIKit

class AnimationView: UIView {
    let text = "Missing You!!~"
    let color = UIColor(red: 0.666, green: 0.745, blue: 0.800, alpha: 0.300).cgColor
    let font = UIFont(name: "BradleyHandITCTT-Bold", size: 80.0)

    override func draw(_ rect: CGRect) {
        // Set up the appearance of the path.
        let newLayer = CAShapeLayer()
        let path = bezierPathFrom(text)
        newLayer.bounds = path.cgPath.boundingBox
        newLayer.path = path.cgPath
        newLayer.strokeEnd = 0
        newLayer.lineWidth = 5
        newLayer.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        newLayer.isGeometryFlipped = true
        newLayer.strokeColor = color
        newLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(newLayer)
        
        // Create the infinity animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 4
        animation.autoreverses = true
        animation.repeatCount = .infinity
        newLayer.add(animation, forKey: "line")
    }

    private func bezierPathFrom(_ text: String) -> UIBezierPath{
        let fontName = __CFStringMakeConstantString(font?.fontName)
        let fontRef = CTFontCreateWithName(fontName!, (font?.pointSize)!, nil)
        
        let attributedString = NSAttributedString(string: text, attributes: [.font : fontRef])
        let line = CTLineCreateWithAttributedString(attributedString as CFAttributedString)
        let allGlyphs = CTLineGetGlyphRuns(line)
        
        let paths = CGMutablePath()
        for glyphIndex in 0..<CFArrayGetCount(allGlyphs) {
            let singleGlyph = CFArrayGetValueAtIndex(allGlyphs, glyphIndex);
            let singleGlyphBits = unsafeBitCast(singleGlyph, to: CTRun.self)
            let ctFontName = unsafeBitCast(kCTFontAttributeName, to: UnsafeRawPointer.self)
            let runFont = CFDictionaryGetValue(CTRunGetAttributes(singleGlyphBits), ctFontName)
            let runFontBits = unsafeBitCast(runFont, to: CTFont.self)
            
            for i in 0..<CTRunGetGlyphCount(singleGlyphBits) {
                let range = CFRangeMake(i, 1)
                let glyph:UnsafeMutablePointer<CGGlyph> = UnsafeMutablePointer<CGGlyph>.allocate(capacity: 1)
                let position:UnsafeMutablePointer<CGPoint> = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
                glyph.initialize(to: 0)
                position.initialize(to: .zero)
                CTRunGetGlyphs(singleGlyphBits, range, glyph)
                CTRunGetPositions(singleGlyphBits, range, position);
 
                let path = CTFontCreatePathForGlyph(runFontBits, glyph.pointee, nil)
                if path != nil {
                    let transform = CGAffineTransform(translationX: position.pointee.x, y: position.pointee.y)
                    paths.addPath(path!, transform: transform)
                }
                
                glyph.deallocate()
                position.deallocate()
            }
        }
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)
        bezierPath.append(UIBezierPath(cgPath: paths))
        
        return bezierPath
    }
}
