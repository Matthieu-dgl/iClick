//
//  Preferences.swift
//  iClick
//
//  Created by Matt on 11/03/2026.
//

import Foundation

struct Preferences {

    private enum Key: String {
        case clickType          = "clickType"
        case clickButton        = "clickButton"
        case intervalSeconds    = "intervalSeconds"
        case holdDurationSeconds = "holdDurationSeconds"
        case language           = "language"
        case hotkeyDisplayString = "hotkeyDisplayString"
        case hotkeyKeyCode      = "hotkeyKeyCode"
    }

    static func save(
        clickType: ClickType,
        clickButton: ClickButton,
        intervalSeconds: Double,
        holdDurationSeconds: Double,
        language: AppLanguage,
        hotkeyDisplayString: String,
        hotkeyKeyCode: UInt16
    ) {
        let d = UserDefaults.standard
        d.set(clickType.rawValue,          forKey: Key.clickType.rawValue)
        d.set(clickButton.rawValue,        forKey: Key.clickButton.rawValue)
        d.set(intervalSeconds,             forKey: Key.intervalSeconds.rawValue)
        d.set(holdDurationSeconds,         forKey: Key.holdDurationSeconds.rawValue)
        d.set(language.rawValue,           forKey: Key.language.rawValue)
        d.set(hotkeyDisplayString,         forKey: Key.hotkeyDisplayString.rawValue)
        d.set(Int(hotkeyKeyCode),          forKey: Key.hotkeyKeyCode.rawValue)
    }

    static func load() -> Snapshot {
        let d = UserDefaults.standard

        let clickType = ClickType(rawValue: d.string(forKey: Key.clickType.rawValue) ?? "") ?? .simple
        let clickButton = ClickButton(rawValue: d.string(forKey: Key.clickButton.rawValue) ?? "") ?? .left
        let interval = d.double(forKey: Key.intervalSeconds.rawValue).nonZeroOr(1.0)
        let hold = d.double(forKey: Key.holdDurationSeconds.rawValue).nonZeroOr(0.5)
        let language = AppLanguage(rawValue: d.string(forKey: Key.language.rawValue) ?? "") ?? .fr
        let hotkeyDisplay = d.string(forKey: Key.hotkeyDisplayString.rawValue) ?? "⌥Space"
        let hotkeyKeyCode = UInt16(d.integer(forKey: Key.hotkeyKeyCode.rawValue).nonZeroOr(49))

        return Snapshot(
            clickType: clickType,
            clickButton: clickButton,
            intervalSeconds: interval,
            holdDurationSeconds: hold,
            language: language,
            hotkeyDisplayString: hotkeyDisplay,
            hotkeyKeyCode: hotkeyKeyCode
        )
    }

    struct Snapshot {
        let clickType: ClickType
        let clickButton: ClickButton
        let intervalSeconds: Double
        let holdDurationSeconds: Double
        let language: AppLanguage
        let hotkeyDisplayString: String
        let hotkeyKeyCode: UInt16
    }
}

private extension Double {
    func nonZeroOr(_ fallback: Double) -> Double {
        self > 0 ? self : fallback
    }
}

private extension Int {
    func nonZeroOr(_ fallback: Int) -> Int {
        self > 0 ? self : fallback
    }
}
