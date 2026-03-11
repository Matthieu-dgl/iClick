//
//  AppLanguage.swift
//  iClick
//
//  Created by Matt on 11/03/2026.
//

import Foundation

enum AppLanguage: String, CaseIterable, Codable {
    case fr = "fr"
    case en = "en"
    case de = "de"
    case es = "es"
    case it = "it"

    var displayName: String {
        switch self {
        case .fr: return "Français"
        case .en: return "English"
        case .de: return "Deutsch"
        case .es: return "Español"
        case .it: return "Italiano"
        }
    }

    var flag: String {
        switch self {
        case .fr: return "🇫🇷"
        case .en: return "🇬🇧"
        case .de: return "🇩🇪"
        case .es: return "🇪🇸"
        case .it: return "🇮🇹"
        }
    }
}
