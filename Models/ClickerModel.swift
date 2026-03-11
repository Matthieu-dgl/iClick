//
//  ClickerModel.swift
//  iClick
//
//  Created by Matt on 11/03/2026.
//

import AppKit

enum ClickType: String, CaseIterable, Codable {
    case simple = "simple"
    case long   = "long"
    case lock   = "lock"
}

enum ClickButton: String, CaseIterable, Codable {
    case left  = "left"
    case right = "right"

    func localizedName(_ lang: AppLanguage) -> String {
        switch (self, lang) {
        case (.left,  .fr): return "Gauche"
        case (.right, .fr): return "Droite"
        case (.left,  .en): return "Left"
        case (.right, .en): return "Right"
        case (.left,  .de): return "Links"
        case (.right, .de): return "Rechts"
        case (.left,  .es): return "Izquierda"
        case (.right, .es): return "Derecha"
        case (.left,  .it): return "Sinistra"
        case (.right, .it): return "Destra"
        }
    }

    var cgEventButton: CGMouseButton {
        self == .left ? .left : .right
    }

    var downEventType: CGEventType {
        self == .left ? .leftMouseDown : .rightMouseDown
    }

    var upEventType: CGEventType {
        self == .left ? .leftMouseUp : .rightMouseUp
    }
}
