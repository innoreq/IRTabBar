//
//  File.swift
//  
//
//  Created by Gerhard Schneider on 15.02.20.
//

import Foundation
import SwiftUI
import UIKit 


extension IRTabBar {
	
	
	public final class Coordinator: NSObject, UITabBarControllerDelegate {
		
		
		var tabBarController: IRTabBar
		var tableDelegate: UITableViewDelegate?
		
		
		init(tabBarController: IRTabBar) {
			
			self.tabBarController = tabBarController
		}
		
		
		public func tabBarController(_ tabBarController: UITabBarController,
									 didSelect viewController: UIViewController) {
			
			if viewController == tabBarController.moreNavigationController && tableDelegate == nil {
				
				if let moreTableView = tabBarController.moreNavigationController.topViewController?.view as? UITableView {
					
					tableDelegate = moreTableView.delegate
					moreTableView.delegate = self
				}
			}
			
			guard let index = tabBarController.customizableViewControllers?.firstIndex(of: viewController)
				else { return }
			
			self.tabBarController.selectedIndex = index
		}
		
		
		public func tabBarController(_ tabBarController: UITabBarController,
									 didEndCustomizing viewControllers: [UIViewController],
									 changed: Bool) {
			
			var newOrder: [Int] = []
			
			if let viewControllers = tabBarController.viewControllers {
				
				for controller in viewControllers {
					
					newOrder.append(controller.tabBarItem.tag)
				}
			}
			
			self.tabBarController.tabOrder = newOrder
		}
	}
}

