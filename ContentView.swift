//
//  ContentView.swift
//  iClick
//
//  Created by Matt on 11/03/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: iClickState
    @State private var selectedTab: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(selectedTab: $selectedTab)

            Divider().opacity(0.5)

            ZStack {
                ClickerView()
                    .opacity(selectedTab == 0 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.15), value: selectedTab)
                SettingsView()
                    .opacity(selectedTab == 1 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.15), value: selectedTab)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider().opacity(0.5)

            FooterView()
        }
        .frame(width: 320, height: 500)
        .background(.windowBackground)
    }
}

struct HeaderView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var state: iClickState

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 9) {
                Image(systemName: "cursorarrow.click.2")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.tint)
                    .symbolRenderingMode(.hierarchical)

                Text("iClick")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer()

                HStack(spacing: 5) {
                    Circle()
                        .fill(state.isRunning ? Color.green : Color.secondary.opacity(0.4))
                        .frame(width: 7, height: 7)
                    Text(state.isRunning ? state.t("status.active") : state.t("status.inactive"))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(state.isRunning ? Color.green : .secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.quaternary, in: Capsule())
            }

            Picker("", selection: $selectedTab) {
                Label(state.t("tab.clicker"), systemImage: "cursorarrow.click").tag(0)
                Label(state.t("tab.settings"), systemImage: "gearshape").tag(1)
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }
}

struct FooterView: View {
    @EnvironmentObject var state: iClickState

    var body: some View {
        HStack {
            Text(state.hotkeyDisplayString)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundStyle(.tertiary)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 4))

            Spacer()

            Button(state.t("quit")) {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 11))
            .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
    }
}


#Preview {
    ContentView()
}
