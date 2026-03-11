//
//  Strings.swift
//  iClick
//
//  Created by Matt on 11/03/2026.
//

import Foundation

struct Strings {
    static func get(_ key: String, language: AppLanguage) -> String {
        return translations[language]?[key] ?? translations[.en]?[key] ?? key
    }
    
    static let translations: [AppLanguage: [String: String]] = [
        .fr: [
            // Tabs
            "tab.clicker": "Clicker",
            "tab.settings": "Paramètres",
            
            // Click types
            "type.simple": "Clic simple",
            "type.long": "Clic long",
            "type.lock": "Clic figé",
            "type.simple.desc": "Clique répétitivement toutes les X secondes",
            "type.long.desc": "Maintient le bouton enfoncé pendant X secondes",
            "type.lock.desc": "Maintient le bouton indéfiniment",
            
            // Controls
            "control.interval": "Intervalle",
            "control.hold": "Durée maintien",
            "control.button": "Bouton",
            "control.seconds": "sec",
            "control.ms": "ms",
            
            // Status
            "status.active": "Actif",
            "status.inactive": "Inactif",
            "status.start": "Démarrer",
            "status.stop": "Arrêter",
            "status.lock.active": "Bouton verrouillé",
            
            // Settings
            "settings.language": "Langue",
            "settings.hotkey": "Raccourci clavier",
            "settings.hotkey.hint": "Cliquez puis appuyez la combinaison souhaitée",
            "settings.hotkey.recording": "Appuyez votre raccourci...",
            "settings.permissions": "Permissions",
            "settings.permissions.accessibility": "Accessibilité requise",
            "settings.permissions.open": "Ouvrir les préférences",
            "settings.version": "Version",
            
            // Permissions
            "perm.title": "Permission requise",
            "perm.message": "iClick nécessite l'accès Accessibilité pour simuler les clics. Ouvrez Préférences Système > Sécurité > Accessibilité.",
            
            // Quit
            "quit": "Quitter iClick",
        ],
        
        .en: [
            "tab.clicker": "Clicker",
            "tab.settings": "Settings",
            
            "type.simple": "Simple Click",
            "type.long": "Long Click",
            "type.lock": "Lock Click",
            "type.simple.desc": "Clicks repeatedly every X seconds",
            "type.long.desc": "Holds button for X seconds",
            "type.lock.desc": "Holds button indefinitely",
            
            "control.interval": "Interval",
            "control.hold": "Hold duration",
            "control.button": "Button",
            "control.seconds": "sec",
            "control.ms": "ms",
            
            "status.active": "Active",
            "status.inactive": "Inactive",
            "status.start": "Start",
            "status.stop": "Stop",
            "status.lock.active": "Button locked",
            
            "settings.language": "Language",
            "settings.hotkey": "Keyboard shortcut",
            "settings.hotkey.hint": "Click then press your desired combination",
            "settings.hotkey.recording": "Press your shortcut...",
            "settings.permissions": "Permissions",
            "settings.permissions.accessibility": "Accessibility required",
            "settings.permissions.open": "Open preferences",
            "settings.version": "Version",
            
            "perm.title": "Permission required",
            "perm.message": "iClick needs Accessibility access to simulate clicks. Open System Preferences > Security > Accessibility.",
            
            "quit": "Quit iClick",
        ],
        
        .de: [
            "tab.clicker": "Klicker",
            "tab.settings": "Einstellungen",
            
            "type.simple": "Einfacher Klick",
            "type.long": "Langer Klick",
            "type.lock": "Gesperrter Klick",
            "type.simple.desc": "Klickt alle X Sekunden wiederholt",
            "type.long.desc": "Hält Taste für X Sekunden gedrückt",
            "type.lock.desc": "Hält Taste unbegrenzt gedrückt",
            
            "control.interval": "Intervall",
            "control.hold": "Haltedauer",
            "control.button": "Taste",
            "control.seconds": "Sek",
            "control.ms": "ms",
            
            "status.active": "Aktiv",
            "status.inactive": "Inaktiv",
            "status.start": "Starten",
            "status.stop": "Stoppen",
            "status.lock.active": "Taste gesperrt",
            
            "settings.language": "Sprache",
            "settings.hotkey": "Tastenkürzel",
            "settings.hotkey.hint": "Klicken und dann gewünschte Kombination drücken",
            "settings.hotkey.recording": "Kürzel drücken...",
            "settings.permissions": "Berechtigungen",
            "settings.permissions.accessibility": "Barrierefreiheit erforderlich",
            "settings.permissions.open": "Einstellungen öffnen",
            "settings.version": "Version",
            
            "perm.title": "Berechtigung erforderlich",
            "perm.message": "iClick benötigt Zugriff auf Bedienungshilfen. Öffnen Sie Systemeinstellungen > Sicherheit > Bedienungshilfen.",
            
            "quit": "iClick beenden",
        ],
        
        .es: [
            "tab.clicker": "Clicker",
            "tab.settings": "Ajustes",
            
            "type.simple": "Clic simple",
            "type.long": "Clic largo",
            "type.lock": "Clic bloqueado",
            "type.simple.desc": "Hace clic repetidamente cada X segundos",
            "type.long.desc": "Mantiene el botón presionado X segundos",
            "type.lock.desc": "Mantiene el botón indefinidamente",
            
            "control.interval": "Intervalo",
            "control.hold": "Duración",
            "control.button": "Botón",
            "control.seconds": "seg",
            "control.ms": "ms",
            
            "status.active": "Activo",
            "status.inactive": "Inactivo",
            "status.start": "Iniciar",
            "status.stop": "Detener",
            "status.lock.active": "Botón bloqueado",
            
            "settings.language": "Idioma",
            "settings.hotkey": "Atajo de teclado",
            "settings.hotkey.hint": "Haz clic y luego pulsa la combinación deseada",
            "settings.hotkey.recording": "Pulsa tu atajo...",
            "settings.permissions": "Permisos",
            "settings.permissions.accessibility": "Accesibilidad requerida",
            "settings.permissions.open": "Abrir preferencias",
            "settings.version": "Versión",
            
            "perm.title": "Permiso requerido",
            "perm.message": "iClick necesita acceso de Accesibilidad. Abre Preferencias del Sistema > Seguridad > Accesibilidad.",
            
            "quit": "Salir de iClick",
        ],
        
        .it: [
            "tab.clicker": "Clicker",
            "tab.settings": "Impostazioni",
            
            "type.simple": "Clic semplice",
            "type.long": "Clic lungo",
            "type.lock": "Clic bloccato",
            "type.simple.desc": "Clicca ripetutamente ogni X secondi",
            "type.long.desc": "Tiene premuto il tasto per X secondi",
            "type.lock.desc": "Tiene premuto il tasto indefinitamente",
            
            "control.interval": "Intervallo",
            "control.hold": "Durata pressione",
            "control.button": "Tasto",
            "control.seconds": "sec",
            "control.ms": "ms",
            
            "status.active": "Attivo",
            "status.inactive": "Inattivo",
            "status.start": "Avvia",
            "status.stop": "Ferma",
            "status.lock.active": "Tasto bloccato",
            
            "settings.language": "Lingua",
            "settings.hotkey": "Scorciatoia tastiera",
            "settings.hotkey.hint": "Clicca e premi la combinazione desiderata",
            "settings.hotkey.recording": "Premi la scorciatoia...",
            "settings.permissions": "Permessi",
            "settings.permissions.accessibility": "Accessibilità richiesta",
            "settings.permissions.open": "Apri preferenze",
            "settings.version": "Versione",
            
            "perm.title": "Permesso richiesto",
            "perm.message": "iClick necessita l'accesso Accessibilità. Apri Preferenze di Sistema > Sicurezza > Accessibilità.",
            
            "quit": "Esci da iClick",
        ],
    ]
}
