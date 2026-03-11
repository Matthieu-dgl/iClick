//
//  ClickerEngine.swift
//  iClick
//
//  Created by Matt on 11/03/2026.
//

import AppKit
import CoreGraphics

final class ClickEngine {

    private var timer: Timer?
    private var isLocked = false

    func start(type: ClickType, button: ClickButton, interval: Double, holdDuration: Double) {
        stop()

        switch type {
        case .simple:
            scheduleRepeating(interval: interval) { [weak self] in
                self?.fireSimpleClick(button: button)
            }
        case .long:
            scheduleRepeating(interval: interval) { [weak self] in
                self?.fireLongClick(button: button, holdDuration: holdDuration)
            }
        case .lock:
            postEvent(type: button.downEventType, button: button)
            isLocked = true
        }
    }

    func stop(button: ClickButton = .left) {
        timer?.invalidate()
        timer = nil

        if isLocked {
            postEvent(type: button.upEventType, button: button)
            isLocked = false
        }
    }

    private func scheduleRepeating(interval: Double, action: @escaping () -> Void) {
        action()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            action()
        }
    }

    private func fireSimpleClick(button: ClickButton) {
        let pos = currentCGPosition()
        postEvent(type: button.downEventType, button: button, at: pos)
        postEvent(type: button.upEventType,   button: button, at: pos)
    }

    private func fireLongClick(button: ClickButton, holdDuration: Double) {
        let pos = currentCGPosition()
        postEvent(type: button.downEventType, button: button, at: pos)

        DispatchQueue.main.asyncAfter(deadline: .now() + holdDuration) { [weak self] in
            guard self?.timer != nil || self?.isLocked == true else { return }
            self?.postEvent(type: button.upEventType, button: button, at: pos)
        }
    }

    private func postEvent(
        type: CGEventType,
        button: ClickButton,
        at position: CGPoint? = nil
    ) {
        let pos = position ?? currentCGPosition()
        let event = CGEvent(
            mouseEventSource: nil,
            mouseType: type,
            mouseCursorPosition: pos,
            mouseButton: button.cgEventButton
        )
        event?.post(tap: .cghidEventTap)
    }

    private func currentCGPosition() -> CGPoint {
        let ns = NSEvent.mouseLocation
        let screenHeight = NSScreen.main?.frame.height ?? 0
        return CGPoint(x: ns.x, y: screenHeight - ns.y)
    }
}
