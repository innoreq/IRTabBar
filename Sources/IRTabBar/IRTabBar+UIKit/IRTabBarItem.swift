//
//  IRTabBarItem.swift
//  HappyFreelancer
//
//  Created by Gerhard Schneider on 09.02.20.
//  Copyright © 2020 Gerhard Schneider. All rights reserved.
//

import Foundation
import SwiftUI


public struct IRTabBarItem {
	
	public var title: String
	public var systemImageName: String
	public var content: AnyView
	public var index: Int

	
	public init(title: String,
				systemImageName: String,
				content: AnyView,
				index: Int) {

		self.title = title
		self.systemImageName = systemImageName
		self.content = content
		self.index = index
	}
}
