//
//  iClickApp.swift
//  iClick
//
//  Created by Matt on 11/03/2026.
//

import SwiftUI
import AppKit

@main
struct iClickApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var globalMonitor: Any?
    var localMonitor: Any?
    
    @ObservedObject var clickerState = iClickState.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        setupStatusItem()
        setupPopover()
        setupGlobalHotkey()
    }
    
    func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "cursorarrow.click", accessibilityDescription: "iClick")
            button.image?.isTemplate = true
            button.action = #selector(togglePopover)
            button.target = self
        }
        
        updateStatusIcon()
    }
    
    func setupPopover() {
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 320, height: 500)
        popover?.behavior = .transient
        popover?.animates = true
        popover?.contentViewController = NSHostingController(
            rootView: ContentView()
                .environmentObject(iClickState.shared)
        )
    }
    
    func updateStatusIcon() {
        let isActive = iClickState.shared.isRunning
        if let button = statusItem?.button {
            let symbolName = isActive ? "cursorarrow.click.2" : "cursorarrow.click"
            button.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "iClick")
            button.image?.isTemplate = true
            
            if isActive {
                button.contentTintColor = NSColor.systemGreen
            } else {
                button.contentTintColor = nil
            }
        }
    }
    
    @objc func togglePopover() {
        guard let button = statusItem?.button else { return }
        
        if let popover = popover {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    func setupGlobalHotkey() {
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleHotkey(event)
        }
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleHotkey(event)
            return event
        }
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(stateChanged),
            name: .iClickStateChanged,
            object: nil)
    }
    
    func handleHotkey(_ event: NSEvent) {
        let state = iClickState.shared
        let prefs = state.hotkeyModifiers
        
        let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        guard modifiers == prefs, event.keyCode == state.hotkeyKeyCode else { return }
        
        state.toggleRunning()
    }
    
    @objc func stateChanged() {
        DispatchQueue.main.async {
            self.updateStatusIcon()
        }
    }
}
