//
//  DALineCounter.swift
//  Hexe
//
//  Created by David Schiefer on 04.01.2023.
//

import Foundation
import Cocoa

class DALineCounter : NSView
{
    var numberOfLines = 1
    var relativeFont = NSFont.systemFont(ofSize: 12.0)
    
    override init(frame frameRect: NSRect)
    {
        super.init(frame:frameRect)
    }
    
    override func draw(_ dirtyRect: NSRect)
    {
        // draw the background
        NSColor.white.setFill()
        NSBezierPath(rect: dirtyRect).fill()
        
        //draw the seperator line
        NSColor.lightGray.setStroke()
        
        let _borderPath = NSBezierPath()
        _borderPath.move(to: NSMakePoint(NSMaxX(dirtyRect), NSMaxY(dirtyRect)))
        _borderPath.line(to: NSMakePoint(NSMaxX(dirtyRect), 0))
        _borderPath.stroke()
        
        // prepare the line markings
        guard let _lineTextFont = NSFont.init(name: "Menlo", size: 10.0) else { NSLog("Can't find the font Menlo!"); return}
        
        let _lineParagraphStyle = NSMutableParagraphStyle.init()
        _lineParagraphStyle.alignment = NSTextAlignment.right
        
        let _lineTextProperties = [NSAttributedString.Key.font : _lineTextFont, NSAttributedString.Key.foregroundColor : NSColor.darkGray, NSAttributedString.Key.paragraphStyle : _lineParagraphStyle]
        
        let _textViewProperties = [NSAttributedString.Key.font : self.relativeFont]
        
        let size = CGSize.init(width: NSWidth(dirtyRect), height: NSHeight(dirtyRect))
        let options = NSString.DrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        for i in 0 ..< numberOfLines
        {
            let _text = String(i) as NSString
            let _lineEstimateFrame = NSString(string: _text).boundingRect(with:size, options:options, attributes:_lineTextProperties, context:nil)
            let _textViewEstimateFrame = NSString(string: "whatever").boundingRect(with:size, options:options, attributes:_textViewProperties, context:nil)
            
            _text.draw(in: NSMakeRect(0.0, NSMaxY(dirtyRect) - (NSHeight(_textViewEstimateFrame) * Double(i)), NSWidth(dirtyRect) * 0.9, _lineEstimateFrame.height), withAttributes:_lineTextProperties)
        }

        super.draw(dirtyRect)
    }

    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
}
