//
//  CMCVColorPickerCellContentView.swift
//  AppKitBridge
//
//  Created by Steven Troughton-Smith on 07/12/2022.
//

import AppKit

/*
 
 This is a contrived example for the purpose of demonstrating this sample code.
 If I were doing this in a shipping app, I might design my custom view differently.
 I thought this one would be pretty :)
 
 */

class CMCVColorPickerCellContentView: NSView {
	
	let itemSize = CGFloat(24)
	let selectionDotSize = CGFloat(6)
	
	let mouseOverExpansion = CGFloat(2)
	
	let padding = CGFloat(4)
	let systemPadding = CGFloat(10)
	
	// MARK: -
	
	var selectedIndex = -1
	
	var labelMenuItem:NSMenuItem? = nil
	
	var mouseLocation = CGPoint.zero
	
	// MARK: -
	
	let colors = [#colorLiteral(red: 0.898, green: 0.306, blue: 0.647, alpha: 1.000),
				  #colorLiteral(red: 0.643, green: 0.522, blue: 0.957, alpha: 1.000),
				  #colorLiteral(red: 0.647, green: 0.765, blue: 0.945, alpha: 1.000),
				  #colorLiteral(red: 0.000, green: 0.769, blue: 0.953, alpha: 1.000),
				  #colorLiteral(red: 0.306, green: 0.886, blue: 0.624, alpha: 1.000),
				  #colorLiteral(red: 0.953, green: 0.902, blue: 0.439, alpha: 1.000),
				  #colorLiteral(red: 0.957, green: 0.537, blue: 0.286, alpha: 1.000)]
	
	let names = ["Pink", "Purple", "Light Blue", "Blue", "Green", "Yellow", "Orange"]
	
	
	// MARK: - Input
	
	func beginMouseTracking() {
		let trackingArea1 = NSTrackingArea(rect: bounds, options: [.mouseMoved, .activeAlways], owner: self)
		addTrackingArea(trackingArea1)
		
		let trackingArea2 = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self)
		addTrackingArea(trackingArea2)
	}
	
	override func mouseDragged(with event: NSEvent) {
		super.mouseDragged(with: event)
		
		mouseMoved(with: event)
	}
	
	override func mouseMoved(with event: NSEvent) {
		super.mouseMoved(with: event)
		
		mouseLocation = convert(event.locationInWindow, to: self)
		setNeedsDisplay(bounds)
	}
	
	override func mouseExited(with event: NSEvent) {
		super.mouseExited(with: event)
		
		mouseLocation = .zero
		
		if selectedIndex >= 0 && selectedIndex < names.count {
			labelMenuItem?.title = names[selectedIndex]
		}
		
		setNeedsDisplay(bounds)
	}
	
	override func mouseUp(with event: NSEvent) {
		super.mouseUp(with: event)
		
		mouseLocation = convert(event.locationInWindow, to: self)
		
		for i in 0 ..< colors.count {
			let subRect = CGRect(x: systemPadding + CGFloat(i) * itemSize, y: 0, width: itemSize, height: itemSize)
			
			if subRect.contains(mouseLocation) {
				selectedIndex = i
				labelMenuItem?.title = names[i]
				
				didSelectItem()
			}
		}
		
		setNeedsDisplay(bounds)
	}
	
	// MARK: - Drawing
	
	override func draw(_ dirtyRect: NSRect) {
		
		for i in 0 ..< colors.count {
			let subRect = CGRect(x: systemPadding + CGFloat(i) * itemSize, y: 0, width: itemSize, height: itemSize)
			colors[i].setFill()
			var circleRect = subRect.insetBy(dx: padding, dy: padding)
			
			if subRect.contains(mouseLocation) {
				circleRect = circleRect.insetBy(dx: -mouseOverExpansion, dy: -mouseOverExpansion)
				labelMenuItem?.title = names[i]
			}
			
			let circle = NSBezierPath(ovalIn: circleRect)
			circle.fill()
			
			/* Border */
			let strokeColor = colors[i].blended(withFraction: 0.3, of: .black) ?? .black
			strokeColor.setStroke()
			
			let lineWidth = CGFloat(1)
			
			let ring = NSBezierPath(ovalIn: circleRect)
			ring.lineWidth = lineWidth
			ring.stroke()
			
			if i == selectedIndex {
				let selectionColor = colors[i].blended(withFraction: 0.5, of: .black) ?? .black
				selectionColor.setFill()
				
				let dot = NSBezierPath(ovalIn: CGRect(origin: CGPoint(x: subRect.midX-selectionDotSize/2, y: subRect.midY-selectionDotSize/2), size: CGSize(width: selectionDotSize, height: selectionDotSize)))
				dot.fill()
			}
		}
	}
	
	
	// MARK: -
	
	/*
	 In this contrived example, we take advantage of the fact that UIColor and NSColor
	 are bridged directly. In your app, you might want a better strategy to pass data
	 between the AppKit and UIKit worlds.
	 */
	
	func didSelectItem() {
		guard selectedIndex >= 0 && selectedIndex < names.count else { return }
		
		let color = colors[selectedIndex]
		NotificationCenter.default.post(name: NSNotification.Name("ColorPickerCellDidPick"), object: color)
	}
	
	// MARK: -
	
	override var intrinsicContentSize: NSSize {
		CGSize(width: systemPadding + (CGFloat(colors.count) * itemSize) + systemPadding, height: itemSize)
	}
}
