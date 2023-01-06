//
//  DASimpleStatusbar.swift
//  Hexe
//
//  Created by David Schiefer on 04.01.2023.
//

import Foundation
import Cocoa

class DASimpleStatusBar : NSView
{
    override init(frame frameRect: NSRect)
    {
        super.init(frame:frameRect)
    }
    
    override func draw(_ dirtyRect: NSRect)
    {
        // draw the border

        let _backgroundGradient = NSGradient(starting: NSColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0),
                                             ending: NSColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0))
        let _backgroundPath = NSBezierPath(rect: dirtyRect)
        
        _backgroundGradient?.draw(in: _backgroundPath, angle: -90.0)
        
        NSColor.lightGray.setStroke()
        
        let _borderPath = NSBezierPath()
        _borderPath.move(to: NSMakePoint(0.0, NSMaxY(dirtyRect)))
        _borderPath.line(to: NSMakePoint(NSMaxX(dirtyRect), _borderPath.currentPoint.y))
        _borderPath.stroke()
        
        
        super.draw(dirtyRect)
    }

    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
}
