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

	
	public init(viewControllers: [UIViewController],
				selectedIndex: Binding<Int>,
				tabOrder: Binding<[Int]>) {
		
		self._selectedIndex = selectedIndex
		self._tabOrder = tabOrder
		self.viewControllers = viewControllers
	}
	
	
	public typealias UIViewControllerType = UITabBarController
	
	
	/// This is the list of tab bar elements that the tab bar shall provide.
	public var viewControllers: [UIViewController] = []
	
	/// This is the currently selected index where the caller must bind to.
	@Binding public var selectedIndex: Int
	
	/// The tab order.
	@Binding public var tabOrder: [Int] {
		
		didSet { debugPrint("tabOrder changed") }
	}
	
	/// Creates a `UIViewController` instance to be presented.
	public func makeUIViewController(context: Self.Context) -> Self.UIViewControllerType {

		debugPrint(">>> IRTabBar: makeUIViewController")
		
		if tabOrder.isEmpty {
			
			self.tabOrder = UserDefaults.standard.object(forKey: "mainTabOrder") as? [Int] ?? []
		}
		
		let tabBarController = UITabBarController()
		
		// We make the context coordinator a delegate for the controller.
		tabBarController.delegate = context.coordinator
		
		// We need the view controllers associated with the items, as well as the items themselves.
		let unsortedViewControllers: [UIViewController] = viewControllers
		
		// Now we sort them according to the current sort order.
		var sortedViewControllers: [UIViewController] = []
		
		if self.viewControllers.isEmpty || tabOrder.isEmpty {
			
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
	public func updateUIViewController(_ uiViewController: Self.UIViewControllerType,
									   context: Self.Context) {
		
	}
	
	
	public func makeCoordinator() -> IRTabBar.Coordinator {
		
		return IRTabBar.Coordinator(tabBarController: self)
	}
}


