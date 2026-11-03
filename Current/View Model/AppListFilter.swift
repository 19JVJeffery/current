//
//  AppListFilter.swift
//  Current
//
//  Created by James Jeffery on 03.11.26.
//  Copyright © 2026 James Jeffery. All rights reserved.
//

import AppKit

/// Filter options for the application list in the UI.
struct AppListFilter: Equatable {
	
	/// Filter for update status
	enum Status: String, CaseIterable, Equatable {
		case all
		case updatesOnly
		case installedOnly
		case ignoredOnly
		
		var displayName: String {
			switch self {
			case .all:
				return NSLocalizedString("FilterAllApps", comment: "Show all apps filter option")
			case .updatesOnly:
				return NSLocalizedString("FilterUpdatesOnly", comment: "Show updates available only filter option")
			case .installedOnly:
				return NSLocalizedString("FilterInstalledOnly", comment: "Show installed apps only filter option")
			case .ignoredOnly:
				return NSLocalizedString("FilterIgnoredOnly", comment: "Show ignored apps only filter option")
			}
		}
	}
	
	/// The source to filter by, or nil to show apps from all sources.
	var source: App.Source?
	
	/// The update status to filter by.
	var status: Status = .all
	
	/// Whether this filter is at its default (unfiltered) state.
	var isDefault: Bool {
		return source == nil && status == .all
	}
	
	static let `default` = AppListFilter()
}
