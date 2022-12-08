//
//  CMCVSceneDelegate+MenuBuilder.swift
//  CatalystMenuCustomViews
//
//  Created by Steven Troughton-Smith on 08/12/2022.
//

import UIKit

extension CMCVAppDelegate {
	
	override func buildMenu(with builder: UIMenuBuilder) {
		if builder.system == UIMenuSystem.context {
			return
		}
		
		builder.remove(menu: .edit)
		builder.remove(menu: .format)

		if #available(iOS 16.0, *) {
			builder.remove(menu: .document)
		}
		
		builder.insertSibling(UIMenu(title: NSLocalizedString("MENU_OPTIONS", comment: ""), identifier: UIMenu.Identifier("ColorSubmenu"), children: []), afterMenu: .view)
	}
}
