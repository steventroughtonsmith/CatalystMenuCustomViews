//
//  CMCVSceneDelegate+NSToolbar.swift
//  CatalystMenuCustomViews
//
//  Created by Steven Troughton-Smith on 07/12/2022.
//  
//

import UIKit

#if targetEnvironment(macCatalyst)
import AppKit

extension CMCVSceneDelegate: NSToolbarDelegate {
    
	func toolbarItems() -> [NSToolbarItem.Identifier] {
		return [.toggleSidebar]
	}
	
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItems()
	}
	
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItems()
	}
	
	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		return NSToolbarItem(itemIdentifier: itemIdentifier)
	}
}
#endif
