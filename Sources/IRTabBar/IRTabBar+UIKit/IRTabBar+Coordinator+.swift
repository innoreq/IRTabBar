//
//  File.swift
//  
//
//  Created by Gerhard Schneider on 15.02.20.
//

import Foundation
import SwiftUI
import UIKit


extension IRTabBar.Coordinator: UITableViewDelegate {
	
	
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		self.tableDelegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
	}
	
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let moreCount = tableView.numberOfRows(inSection: indexPath.section)
		let allCount = self.tabBarController.tabBarItems.count
		
		self.tabBarController.selectedIndex.wrappedValue = allCount - moreCount + indexPath.row
		tableDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
	}
}

