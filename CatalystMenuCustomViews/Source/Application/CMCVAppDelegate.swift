//
//  CMCVAppDelegate.swift
//  CatalystMenuCustomViews
//
//  Created by Steven Troughton-Smith on 07/12/2022.
//  
//

import UIKit

// MARK: AppKit Bridge Interface

extension NSObject {
	@objc class func prepare() {
	}
}

@UIApplicationMain
class CMCVAppDelegate: UIResponder, UIApplicationDelegate {
	
	func loadAppKitBridgeIfNeeded() {
#if targetEnvironment(macCatalyst)
		
		if let frameworksPath = Bundle.main.privateFrameworksPath {
			let bundlePath = "\(frameworksPath)/AppKitBridge.framework"
			do {
				try Bundle(path: bundlePath)?.loadAndReturnError()
				
				_ = Bundle(path: bundlePath)!
				NSLog("[APPKIT BUNDLE] Loaded Successfully")
			
			}
			catch {
				NSLog("[APPKIT BUNDLE] Error loading: \(error)")
			}
		}
		
		if let c = NSClassFromString("AppKitBridge.CMCVSwizzles") as? NSObject.Type {
			c.prepare()
		}
#endif
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		loadAppKitBridgeIfNeeded()
		
		return true
	}
}
