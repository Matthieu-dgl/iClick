//
//  ClickerView.swift
//  iClick
//
//  Created by Matt on 11/03/2026.
//

import SwiftUI

struct ClickerView: View {
    @EnvironmentObject var state: iClickState

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ClickTypeSectionView()
                    .padding(.top, 14)

                Divider()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                ClickParamsView()

                Divider()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                StartStopButton()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 14)
            }
        }
    }
}

struct ClickTypeSectionView: View {
    @EnvironmentObject var state: iClickState

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("TYPE DE CLIC")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)

            VStack(spacing: 1) {
                ForEach(Array(ClickType.allCases.enumerated()), id: \.element) { index, type in
                    ClickTypeRow(type: type, isSelected: state.clickType == type, position: rowPosition(index: index, total: ClickType.allCases.count)) {
                        if !state.isRunning {
                            withAnimation(.easeInOut(duration: 0.12)) {
                                state.clickType = type
                            }
                        }
                    }
                }
            }
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.separator.opacity(0.5), lineWidth: 0.5)
            )
            .padding(.horizontal, 16)
        }
    }

    func rowPosition(index: Int, total: Int) -> RowPosition {
        if total == 1 { return .only }
        if index == 0 { return .top }
        if index == total - 1 { return .bottom }
        return .middle
    }
}

enum RowPosition { case top, middle, bottom, only }

struct ClickTypeRow: View {
    @EnvironmentObject var state: iClickState
    let type: ClickType
    let isSelected: Bool
    let position: RowPosition
    let action: () -> Void

    var icon: String {
        switch type {
        case .simple: return "cursorarrow.click"
        case .long:   return "hand.tap"
        case .lock:   return "lock.fill"
        }
    }

    var title: String {
        switch type {
        case .simple: return state.t("type.simple")
        case .long:   return state.t("type.long")
        case .lock:   return state.t("type.lock")
        }
    }

    var subtitle: String {
        switch type {
        case .simple: return state.t("type.simple.desc")
        case .long:   return state.t("type.long.desc")
        case .lock:   return state.t("type.lock.desc")
        }
    }

    var cornerRadius: (topLeading: CGFloat, topTrailing: CGFloat, bottomLeading: CGFloat, bottomTrailing: CGFloat) {
        let r: CGFloat = 10
        switch position {
        case .top:    return (r, r, 0, 0)
        case .bottom: return (0, 0, r, r)
        case .only:   return (r, r, r, r)
        case .middle: return (0, 0, 0, 0)
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(isSelected ? .white : .secondary)
                    .symbolRenderingMode(.hierarchical)
                    .frame(width: 28, height: 28)
                    .background(isSelected ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 6))

                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.tint)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(state.isRunning)
        .opacity(state.isRunning && !isSelected ? 0.45 : 1)
        .overlay(alignment: .bottom) {
            if position == .top || position == .middle {
                Divider().padding(.leading, 52)
            }
        }
    }
}

struct ClickParamsView: View {
    @EnvironmentObject var state: iClickState

    var body: some View {
        VStack(spacing: 0) {
            FormRow(label: state.t("control.button")) {
                Picker("", selection: $state.clickButton) {
                    ForEach(ClickButton.allCases, id: \.self) { btn in
                        Text(btn.localizedName(state.language)).tag(btn)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 140)
                .disabled(state.isRunning)
            }

            if state.clickType != .lock {
                Divider().padding(.leading, 16)

                FormRow(label: state.t("control.interval")) {
                    HStack(spacing: 8) {
                        Slider(value: $state.intervalSeconds, in: 0.05...10.0)
                            .frame(width: 90)
                            .tint(.accentColor)
                            .disabled(state.isRunning)
                            .onChange(of: state.intervalSeconds) { _ in state.savePreferences() }

                        Text(String(format: "%.2f\(state.t("control.seconds"))", state.intervalSeconds))
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .frame(width: 52, alignment: .trailing)
                    }
                }
            }

            if state.clickType == .long {
                Divider().padding(.leading, 16)

                FormRow(label: state.t("control.hold")) {
                    HStack(spacing: 8) {
                        Slider(value: $state.holdDurationSeconds, in: 0.05...5.0)
                            .frame(width: 90)
                            .tint(.orange)
                            .disabled(state.isRunning)
                            .onChange(of: state.holdDurationSeconds) { _ in state.savePreferences() }

                        Text(String(format: "%.2f\(state.t("control.seconds"))", state.holdDurationSeconds))
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .frame(width: 52, alignment: .trailing)
                    }
                }
            }

            if state.clickType == .lock {
                Divider().padding(.leading, 16)

                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Text(state.t("type.lock.desc"))
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.separator.opacity(0.5), lineWidth: 0.5))
        .padding(.horizontal, 16)
    }
}

struct FormRow<Content: View>: View {
    let label: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(.primary)
            Spacer()
            content()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
    }
}

struct StartStopButton: View {
    @EnvironmentObject var state: iClickState

    var body: some View {
        Button(action: { state.toggleRunning() }) {
            Label(
                state.isRunning ? state.t("status.stop") : state.t("status.start"),
                systemImage: state.isRunning ? "stop.fill" : "play.fill"
            )
            .font(.system(size: 14, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
        }
        .buttonStyle(.borderedProminent)
        .tint(state.isRunning ? .red : .accentColor)
        .controlSize(.large)
    }
}
