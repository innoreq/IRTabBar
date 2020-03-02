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
	public var index: Int
	public var content: AnyView

	
	public init(title: String,
				systemImageName: String,
				index: Int,
				content: AnyView) {

		self.title = title
		self.systemImageName = systemImageName
		self.content = content
		self.index = index
	}
}
