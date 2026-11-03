//
//  SourcesSettingsViewController.swift
//  Current
//
//  Created by James Jeffery on 03.11.26.
//  Copyright © 2026 James Jeffery. All rights reserved.
//

import AppKit

/// Controller for settings of the Sources tab.
class SourcesSettingsViewController: SettingsTabItemViewController {
	
	// MARK: - Properties
	
	private let appStoreCheckbox: NSButton = {
		let button = NSButton(checkboxWithTitle: NSLocalizedString("AppStoreSource", comment: "Mac App Store"), target: nil, action: nil)
		button.font = .systemFont(ofSize: NSFont.systemFontSize, weight: .medium)
		return button
	}()
	
	private let sparkleCheckbox: NSButton = {
		let button = NSButton(checkboxWithTitle: NSLocalizedString("WebSource", comment: "Sparkle / Direct"), target: nil, action: nil)
		button.font = .systemFont(ofSize: NSFont.systemFontSize, weight: .medium)
		return button
	}()
	
	private let homebrewCheckbox: NSButton = {
		let button = NSButton(checkboxWithTitle: NSLocalizedString("HomebrewSource", comment: "Homebrew Cask"), target: nil, action: nil)
		button.font = .systemFont(ofSize: NSFont.systemFontSize, weight: .medium)
		return button
	}()
	
	// MARK: - View Lifecycle
	
	override func loadView() {
		let containerView = NSView(frame: NSRect(x: 0, y: 0, width: 440, height: 260))
		containerView.translatesAutoresizingMaskIntoConstraints = false
		self.view = containerView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		loadSettings()
	}
	
	// MARK: - Setup
	
	private func setupUI() {
		let mainStack = NSStackView()
		mainStack.orientation = .vertical
		mainStack.alignment = .leading
		mainStack.spacing = 16
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(mainStack)
		
		let widthConstraint = mainStack.widthAnchor.constraint(equalToConstant: 400)
		let leadingConstraint = mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
		let topConstraint = mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
		let trailingConstraint = mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
		let bottomConstraint = mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
		
		self.animatingTrailingConstraint = trailingConstraint
		self.animatingBottomConstraint = bottomConstraint
		
		NSLayoutConstraint.activate([
			widthConstraint,
			leadingConstraint,
			topConstraint,
			trailingConstraint,
			bottomConstraint
		])
		
		// Header Label
		let headerLabel = NSTextField(labelWithString: NSLocalizedString("UpdateSourcesHeader", comment: "Check for updates using these platforms:"))
		headerLabel.font = .systemFont(ofSize: NSFont.systemFontSize, weight: .semibold)
		headerLabel.textColor = .labelColor
		mainStack.addArrangedSubview(headerLabel)
		
		// Source Rows
		mainStack.addArrangedSubview(createSourceRow(
			checkbox: appStoreCheckbox,
			icon: App.Source.appStore.sourceIcon,
			description: NSLocalizedString("AppStoreSourceDescription", comment: "Mac App Store description"),
			action: #selector(appStoreToggled(_:))
		))
		
		mainStack.addArrangedSubview(createSourceRow(
			checkbox: sparkleCheckbox,
			icon: App.Source.sparkle.sourceIcon,
			description: NSLocalizedString("SparkleSourceDescription", comment: "Sparkle description"),
			action: #selector(sparkleToggled(_:))
		))
		
		mainStack.addArrangedSubview(createSourceRow(
			checkbox: homebrewCheckbox,
			icon: App.Source.homebrew.sourceIcon,
			description: NSLocalizedString("HomebrewSourceDescription", comment: "Homebrew description"),
			action: #selector(homebrewToggled(_:))
		))
	}
	
	private func createSourceRow(checkbox: NSButton, icon: NSImage?, description: String, action: Selector) -> NSView {
		let rowView = NSView()
		rowView.translatesAutoresizingMaskIntoConstraints = false
		
		checkbox.target = self
		checkbox.action = action
		checkbox.translatesAutoresizingMaskIntoConstraints = false
		rowView.addSubview(checkbox)
		
		let imageView = NSImageView()
		imageView.image = icon
		imageView.imageScaling = .scaleProportionallyUpOrDown
		imageView.translatesAutoresizingMaskIntoConstraints = false
		rowView.addSubview(imageView)
		
		let descLabel = NSTextField(wrappingLabelWithString: description)
		descLabel.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
		descLabel.textColor = .secondaryLabelColor
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		rowView.addSubview(descLabel)
		
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
			imageView.topAnchor.constraint(equalTo: rowView.topAnchor, constant: 1),
			imageView.widthAnchor.constraint(equalToConstant: 20),
			imageView.heightAnchor.constraint(equalToConstant: 20),
			
			checkbox.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
			checkbox.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
			checkbox.trailingAnchor.constraint(lessThanOrEqualTo: rowView.trailingAnchor),
			
			descLabel.leadingAnchor.constraint(equalTo: checkbox.leadingAnchor, constant: 20),
			descLabel.topAnchor.constraint(equalTo: checkbox.bottomAnchor, constant: 2),
			descLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
			descLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
		])
		
		return rowView
	}
	
	// MARK: - Settings Management
	
	private func loadSettings() {
		appStoreCheckbox.state = UpdateCheckSettings.shared.isAppStoreEnabled ? .on : .off
		sparkleCheckbox.state = UpdateCheckSettings.shared.isSparkleEnabled ? .on : .off
		homebrewCheckbox.state = UpdateCheckSettings.shared.isHomebrewEnabled ? .on : .off
	}
	
	@objc private func appStoreToggled(_ sender: NSButton) {
		UpdateCheckSettings.shared.isAppStoreEnabled = (sender.state == .on)
	}
	
	@objc private func sparkleToggled(_ sender: NSButton) {
		UpdateCheckSettings.shared.isSparkleEnabled = (sender.state == .on)
	}
	
	@objc private func homebrewToggled(_ sender: NSButton) {
		UpdateCheckSettings.shared.isHomebrewEnabled = (sender.state == .on)
	}
	
}
