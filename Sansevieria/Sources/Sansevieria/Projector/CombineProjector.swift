//
//  CombineProjector.swift
//

import Foundation
import CoreGraphics

final class Combinator {
    let left: Projector
    let right: Projector

    var duration: TimeInterval = 0.0
    var valueFomula: (Combinator, TimeInterval) -> CGFloat = { _, _ in 0 }

    init(_ left: Projector, _ right: Projector) {
        self.left = left
        self.right = right
    }

    func duration(_ duration: TimeInterval) -> Self {
        self.duration = duration
        return self
    }

    func formula(_ formula: @escaping (Combinator, TimeInterval) -> CGFloat) -> Self {
        valueFomula = formula
        return self
    }

    func build() -> some Projector {
        CombinedProjector(source: self)
    }
}

final class CombinedProjector: Projector {

    let source: Combinator

    init(source: Combinator) {
        self.source = source
    }

    var duration: TimeInterval { source.duration }

    func value(at time: TimeInterval) -> CGFloat {
        source.valueFomula(source, time)
    }
}

// MARK: - Combine Utilities.

extension Projector {

    public func continuous<Target: Projector>(to target: Target) -> some Projector {
        Combinator(self, target)
            .duration(self.duration + target.duration)
            .formula { source, time in
                if time <= source.left.duration {
                    return source.left.value(at: time) + source.right.value(at: 0)
                } else {
                    return source.left.value(at: source.left.duration) + source.right.value(at: time - source.left.duration)
                }
            }
            .build()
    }

    public func add<Target: Projector>(_ target: Target) -> some Projector {
        Combinator(self, target.stretch(self.duration))
            .duration(self.duration)
            .formula { source, time in
                source.left.value(at: time) + source.right.value(at: time)
            }
            .build()
    }

    public func multiply<Target: Projector>(_ target: Target) -> some Projector {
        Combinator(self, target.stretch(self.duration))
            .duration(self.duration)
            .formula { source, time in
                source.left.value(at: time) * source.right.value(at: time)
            }
            .build()
    }
}

// MARK: - Projector Expression

extension Projector {

    // Connects left projector to right projector. (right projector is running after left projector)
    // Total Duration: left + right
    public static func >> <Target: Projector> (left: Self, right: Target) -> some Projector {
        left.continuous(to: right)
    }

    // Addition tow projector's value, and right duration stretch to left duration.
    // Total Duration: left
    public static func + <Target: Projector> (left: Self, right: Target) -> some Projector {
        left.add(right)
    }

    // Multiplition tow projector's value, and right duration stretch to left duration.
    // Total Duration: left
    public static func * <Target: Projector> (left: Self, right: Target) -> some Projector {
        left.multiply(right)
    }
}
