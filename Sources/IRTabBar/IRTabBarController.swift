//
//  IRTabBar.swift
//  HappyFreelancer
//
//  Created by Gerhard Schneider on 09.02.20.
//  Copyright © 2020 Gerhard Schneider. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


/// Provides a tab bar that reacts on tab changes and reordering.
public struct IRTabBar: UIViewControllerRepresentable {
	
	
	public init(viewControllers: [UIViewController], selectedIndex: Binding<Int>, tabOrder: Binding<[Int]>) {
		
		self._selectedIndex = selectedIndex
		self._tabOrder = tabOrder
	}
	
	
	public typealias UIViewControllerType = UITabBarController
	
	
	/// This is the list of tab bar elements that the tab bar shall provide.
	public var viewControllers: [UIViewController] = []
	
	/// This is the currently selected index where the caller must bind to.
	@Binding public var selectedIndex: Int
	
	/// The tab order.
	@Binding public var tabOrder: [Int]
	
	/// Creates a `UIViewController` instance to be presented.
	public func makeUIViewController(context: Self.Context) -> Self.UIViewControllerType {
		
		let tabBarController = UITabBarController()
		
		// We make the context coordinator a delegate for the controller.
		tabBarController.delegate = context.coordinator
		
		// We need the view controllers associated with the items, as well as the items themselves.
		let unsortedViewControllers: [UIViewController] = viewControllers
		
		// Now we sort them according to the current sort order.
		var sortedViewControllers: [UIViewController] = []
		
		if tabOrder.isEmpty {
			
			sortedViewControllers = unsortedViewControllers
		} else {
			
			for index in 0..<tabOrder.count {
				
				sortedViewControllers.append(unsortedViewControllers[tabOrder[index]])
			}
		}
		
		// Finally set the view controllers.
		tabBarController.setViewControllers(sortedViewControllers,
											animated: true)
		
		// Activate the selected one.
		tabBarController.selectedViewController = sortedViewControllers[selectedIndex]
		
		return tabBarController
	}
	
	
	/// Updates the presented `UIViewController` (and coordinator) to the latest
	/// configuration.
	public func updateUIViewController(_ uiViewController: Self.UIViewControllerType, context: Self.Context) {
		
	}
	
	
	public func makeCoordinator() -> IRTabBar.Coordinator {
		
		return IRTabBar.Coordinator(tabBarController: self)
	}
}



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
			
			guard let index = tabBarController.customizableViewControllers?.index(of: viewController)
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


extension IRTabBar.Coordinator: UITableViewDelegate {
	
	
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		self.tableDelegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
	}
	
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let moreCount = tableView.numberOfRows(inSection: indexPath.section)
		let allCount = self.tabBarController.viewControllers.count
		
		self.tabBarController.selectedIndex = allCount - moreCount + indexPath.row
		tableDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
	}
}
