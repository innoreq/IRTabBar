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

	
	public init(tabBarItems: [IRTabBarItem],
				selectedIndex: Binding<Int>,
				tabOrder: Binding<[Int]>) {
		
		self.selectedIndex = selectedIndex
		self.tabOrder = tabOrder
		self.tabBarItems = tabBarItems
	}
	
	
	public typealias UIViewControllerType = UITabBarController
	
	
	/// The tab bar items to present.
	var tabBarItems: [IRTabBarItem]
	
	/// This is the currently selected index where the caller must bind to.
	public var selectedIndex: Binding<Int> {
		
		didSet { debugPrint("selectedIndex changed") }
	}
	
	/// The tab order.
	public var tabOrder: Binding<[Int]> {
		
		didSet { debugPrint("tabOrder changed") }
	}
	
	/// Creates a `UIViewController` instance to be presented.
	public func makeUIViewController(context: Self.Context) -> Self.UIViewControllerType {

		debugPrint(">>> IRTabBar: makeUIViewController")
		
		if tabOrder.wrappedValue.isEmpty {
			
			self.tabOrder.wrappedValue = UserDefaults.standard.object(forKey: "mainTabOrder") as? [Int] ?? []
		}
		
		let tabBarController = UITabBarController()
		
		// We make the context coordinator a delegate for the controller.
		tabBarController.delegate = context.coordinator
		
		// We need the view controllers associated with the items, as well as the items themselves.
		let unsortedViewControllers: [UIViewController] = tabBarItems.map({
			
			let vc = UIHostingController(rootView: $0.content)
			vc.tabBarItem = UITabBarItem(title: $0.title,
										 image: UIImage(systemName: $0.systemImageName),
										 tag: $0.index)
			return vc
		})
		
		// Now we sort them according to the current sort order.
		var sortedViewControllers: [UIViewController] = []
		
		if self.tabBarItems.isEmpty || tabOrder.wrappedValue.isEmpty {
			
			sortedViewControllers = unsortedViewControllers
		} else {
			
			for index in 0..<tabOrder.wrappedValue.count {
				
				sortedViewControllers.append(unsortedViewControllers[tabOrder.wrappedValue[index]])
			}
		}
		
		// Finally set the view controllers.
		tabBarController.setViewControllers(sortedViewControllers,
											animated: true)
		
		// Activate the selected one.
		tabBarController.selectedViewController = sortedViewControllers[selectedIndex.wrappedValue]
		
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


