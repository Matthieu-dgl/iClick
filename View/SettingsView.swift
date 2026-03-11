//
//  SettingsView.swift
//  iClick
//
//  Created by Matt on 11/03/2026.
//

import SwiftUI
import AppKit

struct SettingsView: View {
    @EnvironmentObject var state: iClickState
    @State private var isRecordingHotkey = false
    @State private var hotkeyMonitor: Any?
    @State private var hasAccessibility = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {

                SectionHeader(title: state.t("settings.language"))
                    .padding(.top, 14)

                VStack(spacing: 1) {
                    ForEach(Array(AppLanguage.allCases.enumerated()), id: \.element) { index, lang in
                        LanguageRow(lang: lang, isSelected: state.language == lang, isLast: index == AppLanguage.allCases.count - 1) {
                            withAnimation(.easeInOut(duration: 0.12)) {
                                state.language = lang
                                state.savePreferences()
                            }
                        }
                    }
                }
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.separator.opacity(0.5), lineWidth: 0.5))
                .padding(.horizontal, 16)

                SectionHeader(title: state.t("settings.hotkey"))
                    .padding(.top, 18)

                VStack(spacing: 0) {
                    HStack {
                        Text(state.t("settings.hotkey"))
                            .font(.system(size: 13))
                            .foregroundStyle(.primary)
                        Spacer()
                        HotkeyButton(
                            isRecording: isRecordingHotkey,
                            displayString: state.hotkeyDisplayString
                        ) {
                            isRecordingHotkey ? stopRecording() : startRecording()
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)

                    if isRecordingHotkey {
                        Divider().padding(.leading, 12)
                        HStack(spacing: 6) {
                            Image(systemName: "record.circle.fill")
                                .foregroundStyle(.red)
                                .font(.system(size: 11))
                            Text(state.t("settings.hotkey.recording"))
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button(state.t("cancel")) { stopRecording() }
                                .buttonStyle(.plain)
                                .font(.system(size: 11))
                                .foregroundStyle(.tint)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                }
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.separator.opacity(0.5), lineWidth: 0.5))
                .padding(.horizontal, 16)

                SectionHeader(title: state.t("settings.permissions"))
                    .padding(.top, 18)

                VStack(spacing: 0) {
                    HStack(spacing: 10) {
                        Image(systemName: hasAccessibility ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(hasAccessibility ? .green : .orange)
                            .symbolRenderingMode(.hierarchical)

                        VStack(alignment: .leading, spacing: 1) {
                            Text(state.t("settings.permissions.accessibility"))
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.primary)
                            Text(hasAccessibility ? "Activé" : state.t("perm.message"))
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)

                    if !hasAccessibility {
                        Divider().padding(.leading, 12)
                        Button(action: {
                            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
                        }) {
                            HStack {
                                Text(state.t("settings.permissions.open"))
                                    .font(.system(size: 13))
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 11, weight: .medium))
                            }
                            .foregroundStyle(.tint)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.separator.opacity(0.5), lineWidth: 0.5))
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
            }
        }
        .onAppear { checkAccessibility() }
    }

    func checkAccessibility() {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: false] as CFDictionary
        hasAccessibility = AXIsProcessTrustedWithOptions(options)
    }

    func startRecording() {
        isRecordingHotkey = true
        hotkeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            guard !modifiers.isEmpty else { return event }

            let keyName = keyCodeToString(event.keyCode)
            var parts: [String] = []
            if modifiers.contains(.control) { parts.append("⌃") }
            if modifiers.contains(.option)  { parts.append("⌥") }
            if modifiers.contains(.command) { parts.append("⌘") }
            if modifiers.contains(.shift)   { parts.append("⇧") }
            parts.append(keyName)

            self.state.hotkeyModifiers = modifiers
            self.state.hotkeyKeyCode = event.keyCode
            self.state.hotkeyDisplayString = parts.joined(separator: "")
            self.state.savePreferences()
            self.stopRecording()
            return nil
        }
    }

    func stopRecording() {
        isRecordingHotkey = false
        if let monitor = hotkeyMonitor { NSEvent.removeMonitor(monitor); hotkeyMonitor = nil }
    }

    func keyCodeToString(_ keyCode: UInt16) -> String {
        let map: [UInt16: String] = [
            49:"Space",36:"↩",51:"⌫",53:"Esc",
            123:"←",124:"→",125:"↓",126:"↑",
            18:"1",19:"2",20:"3",21:"4",23:"5",22:"6",26:"7",28:"8",25:"9",29:"0",
            0:"A",11:"B",8:"C",2:"D",14:"E",3:"F",5:"G",4:"H",34:"I",38:"J",
            40:"K",37:"L",46:"M",45:"N",31:"O",35:"P",12:"Q",15:"R",1:"S",17:"T",
            32:"U",9:"V",13:"W",7:"X",16:"Y",6:"Z"
        ]
        return map[keyCode] ?? "F\(keyCode)"
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 5)
    }
}

struct LanguageRow: View {
    let lang: AppLanguage
    let isSelected: Bool
    let isLast: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(lang.flag)
                    .font(.system(size: 16))
                Text(lang.displayName)
                    .font(.system(size: 13))
                    .foregroundStyle(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.tint)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            if !isLast { Divider().padding(.leading, 12) }
        }
    }
}

struct HotkeyButton: View {
    let isRecording: Bool
    let displayString: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(isRecording ? "…" : displayString)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(isRecording ? .red : .primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(isRecording ? Color.red.opacity(0.5) : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    SettingsView()
}
