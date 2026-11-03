//
//  UpdateGroupRowView.swift
//  Current
//
//  Created by Max Langer on 15.08.18.
//  Copyright © 2018 Max Langer. All rights reserved.
//

import Cocoa

/// The row view used by the group rows in the update tableView
class UpdateGroupRowView: NSTableRowView {
	
	private let visualEffectView: NSVisualEffectView = {
		let view = NSVisualEffectView()
		view.blendingMode = .withinWindow
		view.material = .headerView
		view.state = .followsWindowActiveState
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let separatorView: NSBox = {
		let box = NSBox()
		box.boxType = .separator
		box.translatesAutoresizingMaskIntoConstraints = false
		return box
	}()

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		setupViews()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
	}

	private func setupViews() {
		wantsLayer = true
		addSubview(visualEffectView, positioned: .below, relativeTo: nil)
		addSubview(separatorView, positioned: .above, relativeTo: visualEffectView)
		
		NSLayoutConstraint.activate([
			visualEffectView.topAnchor.constraint(equalTo: topAnchor),
			visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
			visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
			visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
			
			separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
			separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
			separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
			separatorView.heightAnchor.constraint(equalToConstant: 1)
		])
		
		separatorView.isHidden = !isFloating
	}

	override var isFloating: Bool {
		didSet {
			separatorView.isHidden = !isFloating
		}
	}

	// Prevent any row view drawing
	override func draw(_ dirtyRect: NSRect) {}
}
