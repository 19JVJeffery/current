//
//  UpdateCheckSettings.swift
//  Current
//
//  Created by Max Langer on 23.01.20.
//  Copyright © 2020 Max Langer. All rights reserved.
//

import Foundation

/// A manager for settings regarding update checks
struct UpdateCheckSettings: Observable {
	
	enum Setting: String, CaseIterable {
		case appLocations
		case enableAppStore
		case enableSparkle
		case enableHomebrew
		
		var userDefaultsKey: String {
			rawValue + "UserDefaultsKey"
		}
		
		var defaultValue: Any {
			switch self {
			case .appLocations:
				return true
			case .enableAppStore, .enableSparkle, .enableHomebrew:
				return true
			}
		}
	}
	
	// MARK: Properties
	
	var observers = [UUID : ObservationHandler]()
	
	private init() {
		let settings: [(key: String, value: Any)] = Setting.allCases.map { setting in
			return (setting.userDefaultsKey, setting.defaultValue)
		}
		UserDefaults.standard.register(defaults: Dictionary(uniqueKeysWithValues: settings))
	}
	
	/// The shared update check settings
	static var shared = UpdateCheckSettings()
	
	
	// MARK: - Update Sources
	
	/// Whether Mac App Store updates are enabled
	var isAppStoreEnabled: Bool {
		get { UserDefaults.standard.bool(forKey: Setting.enableAppStore.userDefaultsKey) }
		nonmutating set { set(newValue, for: .enableAppStore) }
	}
	
	/// Whether Sparkle (Direct/Web) updates are enabled
	var isSparkleEnabled: Bool {
		get { UserDefaults.standard.bool(forKey: Setting.enableSparkle.userDefaultsKey) }
		nonmutating set { set(newValue, for: .enableSparkle) }
	}
	
	/// Whether Homebrew Cask updates are enabled
	var isHomebrewEnabled: Bool {
		get { UserDefaults.standard.bool(forKey: Setting.enableHomebrew.userDefaultsKey) }
		nonmutating set { set(newValue, for: .enableHomebrew) }
	}
	
	/// Returns whether the specified source is enabled in settings
	func isSourceEnabled(_ source: App.Source) -> Bool {
		switch source {
		case .appStore:
			return self.isAppStoreEnabled
		case .sparkle:
			return self.isSparkleEnabled
		case .homebrew:
			return self.isHomebrewEnabled
		case .none:
			return true
		}
	}
	
	/// Enables or disables the specified source
	func setSource(_ source: App.Source, enabled: Bool) {
		switch source {
		case .appStore:
			self.isAppStoreEnabled = enabled
		case .sparkle:
			self.isSparkleEnabled = enabled
		case .homebrew:
			self.isHomebrewEnabled = enabled
		case .none:
			break
		}
	}
	
	
	// MARK: - App Locations
	
	/// The paths to look for apps that are searched by the user
	var userAppLocations: [URL] {
		get {
			return (UserDefaults.standard.array(forKey: Setting.appLocations.userDefaultsKey) as? [String])?.compactMap {
				URL(fileURLWithPath: $0)
			} ?? []
		}
		nonmutating set {
			let pathStrings = newValue.map { $0.path }
			self.set(pathStrings, for: .appLocations)
		}
	}
	
	// MARK: - Utilities
	
	private func set(_ value: Any, for setting: Setting) {
		UserDefaults.standard.set(value, forKey: setting.userDefaultsKey)
		
		DispatchQueue.main.async {
			self.notify()
		}
	}
	
}
