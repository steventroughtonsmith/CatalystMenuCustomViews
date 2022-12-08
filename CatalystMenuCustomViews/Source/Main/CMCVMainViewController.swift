//
//  CMCVMainViewController.swift
//  CatalystMenuCustomViews
//
//  Created by Steven Troughton-Smith on 07/12/2022.
//  
//

import UIKit
import AppleUniversalCore

// MARK: -

final class CCSPMainViewController: UIViewController, UIContextMenuInteractionDelegate {
		
	let optionsButton = {
		let button = UIButton(type: .system)
		button.setTitle(NSLocalizedString("BUTTON_MENU", comment: ""), for: .normal)
		
		button.showsMenuAsPrimaryAction = true
		
		return button
	} ()
	
	// MARK: -
	
	init() {
		super.init(nibName: nil, bundle: nil)
		title = "CatalystCustomSavePanels"
		
		view.backgroundColor = .systemBackground

		optionsButton.menu = sharedOptionsMenu()
		view.addSubview(optionsButton)
		
		let ctx = UIContextMenuInteraction(delegate: self)
		view.addInteraction(ctx)
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name("ColorPickerCellDidPick"), object: nil, queue: nil) { [weak self] notification in
			if let color = notification.object as? UIColor {
				self?.view.backgroundColor = color
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Layout
	
	override func viewDidLayoutSubviews() {
		
		let safeFrame = view.bounds.inset(by: view.safeAreaInsets)
		
		optionsButton.sizeToFit()
		optionsButton.frame = optionsButton.bounds.centered(in: safeFrame)
	}
	
	// MARK: - Actions
	
	func sharedOptionsMenu() -> UIMenu {
		var items:[UIMenuElement] = []
	
		do {
			/*
			 We're going to intercept this menu identifier over in AppKit land
			 and replace the submenu with our own NSMenuItems
			 */
			items.append(UIMenu(title:NSLocalizedString("MENU_STYLE", comment: ""), identifier: UIMenu.Identifier("ColorSubmenu"), children: []))
		}
		
		return UIMenu(children: items)
	}
	
	// MARK: - Context Interaction (Right-Click)
	
	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [weak self] suggestedActions in
			return self?.sharedOptionsMenu()
		})
	}
}
