//
//  ClickerState.swift
//  iClick
//
//  Created by Matt on 11/03/2026.
//

import SwiftUI
import AppKit
import Combine

final class iClickState: ObservableObject {

    static let shared = iClickState()

    @Published var clickType: ClickType = .simple
    @Published var clickButton: ClickButton = .left
    @Published var intervalSeconds: Double = 1.0
    @Published var holdDurationSeconds: Double = 0.5
    @Published var isRunning: Bool = false

    @Published var hotkeyModifiers: NSEvent.ModifierFlags = [.option]
    @Published var hotkeyKeyCode: UInt16 = 49
    @Published var hotkeyDisplayString: String = "⌥Space"

    @Published var language: AppLanguage = .fr

    private let engine = ClickEngine()

    private init() {
        restore()
    }

    func toggleRunning() {
        isRunning ? stop() : start()
    }

    func start() {
        isRunning = true
        engine.start(
            type: clickType,
            button: clickButton,
            interval: intervalSeconds,
            holdDuration: holdDurationSeconds
        )
        postStateChange()
    }

    func stop() {
        engine.stop(button: clickButton)
        isRunning = false
        postStateChange()
    }

    func savePreferences() {
        Preferences.save(
            clickType: clickType,
            clickButton: clickButton,
            intervalSeconds: intervalSeconds,
            holdDurationSeconds: holdDurationSeconds,
            language: language,
            hotkeyDisplayString: hotkeyDisplayString,
            hotkeyKeyCode: hotkeyKeyCode
        )
    }

    private func restore() {
        let snap = Preferences.load()
        clickType           = snap.clickType
        clickButton         = snap.clickButton
        intervalSeconds     = snap.intervalSeconds
        holdDurationSeconds = snap.holdDurationSeconds
        language            = snap.language
        hotkeyDisplayString = snap.hotkeyDisplayString
        hotkeyKeyCode       = snap.hotkeyKeyCode
    }

    func t(_ key: String) -> String {
        Strings.get(key, language: language)
    }

    private func postStateChange() {
        NotificationCenter.default.post(name: .iClickStateChanged, object: nil)
    }
}

extension Notification.Name {
    static let iClickStateChanged = Notification.Name("iClickStateChanged")
}
