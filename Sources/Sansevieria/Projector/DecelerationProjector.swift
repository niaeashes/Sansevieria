//
//  DecelerationProjector.swift
//

import SwiftUI

public class DecelerationProjector: Projector {

    #if TARGET_OS_IPHONE
    public typealias DecelerationRate = UIScrollView.DecelerationRate
    #else
    public enum DecelerationRate: CGFloat {
        case normal = 0.998
        case fast = 0.99
    }
    #endif

    let initialVelocity: CGFloat  // pixel per second
    let decelerationRate: CGFloat // deceleration rate per milisecond

    public init(initialVelocity: CGFloat, decelerationRate: DecelerationRate) {

        self.initialVelocity = initialVelocity
        self.decelerationRate = decelerationRate.rawValue
    }

    public convenience init(from initialPoint: CGFloat, to finalPoint: CGFloat) {
        self.init(
            initialVelocity: (finalPoint - initialPoint) * 10,
            decelerationRate: .fast)
    }

    public convenience init(initialVelocity: CGFloat, from initialPoint: CGFloat, to finalPoint: CGFloat) {
        self.init(
            initialVelocity: initialVelocity,
            decelerationRate: .fast)
    }

    public var dCoeff: CGFloat { 1000 * log(decelerationRate) }
    var result: CGFloat { value(at: duration) }

    public func velocity(at time: TimeInterval) -> CGFloat {
        initialVelocity * pow(decelerationRate, CGFloat(1000 * time))
    }

    public func value(at time: TimeInterval) -> CGFloat {
        (pow(decelerationRate, CGFloat(1000 * time /* If in 1 sec, 1000th power */ )) - 1) / dCoeff * initialVelocity
    }

    public var duration: TimeInterval {
        guard abs(initialVelocity) > 0 else { return 0 }
        return TimeInterval(log(-dCoeff / abs(initialVelocity)) / dCoeff)
    }
}

// MARK: - bouse animation.
extension DecelerationProjector {

    func getDuration(to range: CGFloat, point: CGFloat = 0) -> TimeInterval {
        guard 0 < range else { return 0 }
        return TimeInterval(log(1 - (point - range) * dCoeff / abs(initialVelocity) ) / dCoeff)
    }

    public func bounse(at offset: CGFloat, current: CGFloat) -> Projector {

        if current < offset, current + value(at: duration) > offset {
            let duration = duration
            let targetDuration = getDuration(to: offset - current)
            guard targetDuration < duration else { return self }
            let spring = Spring.defaultSpring
                .conflict(velocity: velocity(at: targetDuration) / 3.0)
                .stretch(1.0 / 3.0)
            return self.trim(head: targetDuration).continuous(to: spring)
        }

        if offset < current, offset > current + value(at: duration) {
            let duration = duration
            let targetDuration = getDuration(to: current - offset)
            guard targetDuration < duration else { return self }
            let spring = Spring.defaultSpring
                .conflict(velocity: velocity(at: targetDuration) / 3.0)
                .stretch(1.0 / 3.0)
            return self.trim(head: targetDuration).continuous(to: spring)
        }

        return self
    }
}
