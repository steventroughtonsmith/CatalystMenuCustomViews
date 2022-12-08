//
//  CMCVSwizzles.swift
//  AppKitBridge
//
//  Created by Steven Troughton-Smith on 07/12/2022.
//

import AppKit

func CMCV_InterceptNSMenuItem(_ item:NSMenuItem) {
	guard let identifier = item.identifier else { return }
	NSLog("[MENU ITEM] \(identifier)")
	
	if identifier.rawValue == "ColorSubmenu" {
		let labelItem = NSMenuItem(title: NSLocalizedString("MENU_COLORLABEL_TEMPLATE", comment: ""), action: nil, keyEquivalent: "")
		
		let newItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
		
		let colorPickerView = CMCVColorPickerCellContentView()
		colorPickerView.frame = CGRect(origin: .zero, size: colorPickerView.intrinsicContentSize)
		colorPickerView.labelMenuItem = labelItem
		
		newItem.view = colorPickerView
		colorPickerView.beginMouseTracking()
		
		item.submenu?.items.append(labelItem)
		item.submenu?.items.append(newItem)
	}
	else {
		CMCV_InterceptNSMenuAndPrepareCustomViews(item.submenu)
	}
	
}

func CMCV_InterceptNSMenuAndPrepareCustomViews(_ nsMenu:NSMenu?) {
	guard let nsMenu = nsMenu else { return }
	
	for item in nsMenu.items {
		CMCV_InterceptNSMenuItem(item)
	}
}

extension NSPopUpButton {
	
	@objc func CMCV_setUINSMenu(_ menu:NSObject) {
		
		CMCV_setUINSMenu(menu)
		
		CMCV_InterceptNSMenuAndPrepareCustomViews(self.menu)
	}
}

extension NSObject {
	
	@objc(CMCV_createNSMenu:forContextMenu:) func CMCV_createNSMenu(_ nsMenuPointer: UnsafeMutablePointer<NSObject>, forContextMenu:UnsafeMutablePointer<NSObject>?) -> NSObject {
		
		let original = CMCV_createNSMenu(nsMenuPointer, forContextMenu: forContextMenu)
		
		if let nsMenu = original as? NSMenu {
			CMCV_InterceptNSMenuAndPrepareCustomViews(nsMenu)
		}
		
		return original
	}
}

class CMCVSwizzles: NSObject {
	@objc class func prepare() {
		NSLog("Loaded swizzles");
		
		/*
		 This swizzle enables intercepting the menu of pop-up or pull-down buttons
		 */
		do {
			let m1 = class_getInstanceMethod(NSClassFromString("NSPopUpButton"), NSSelectorFromString("setUINSMenu:"))
			let m2 = class_getInstanceMethod(NSClassFromString("NSPopUpButton"), NSSelectorFromString("CMCV_setUINSMenu:"))
			if let m1 = m1, let m2 = m2 {
				method_exchangeImplementations(m1, m2)
			}
		}
		
		/*
		 This swizzle enables intercepting context menus and the main menu bar
		 */
		do {
			let m1 = class_getInstanceMethod(NSClassFromString("UINSMenuController"), NSSelectorFromString("_createNSMenu:forContextMenu:"))
			let m2 = class_getInstanceMethod(NSClassFromString("UINSMenuController"), NSSelectorFromString("CMCV_createNSMenu:forContextMenu:"))
			if let m1 = m1, let m2 = m2 {
				method_exchangeImplementations(m1, m2)
			}
		}
	}
}
