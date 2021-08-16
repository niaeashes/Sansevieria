//
//  TransformProjector.swift
//  
//

import SwiftUI

public final class TransformProjector<Source: Projector>: Projector {

    let projector: Source
    var timeTransformer: (Double) -> Double = { $0 }
    var valueFransformer: (CGFloat, Double) -> CGFloat = { value, _ in value }

    public private(set) var duration: TimeInterval

    init(source projector: Source) {
        self.projector = projector
        self.duration = projector.duration
    }

    public func value(at time: TimeInterval) -> CGFloat {
        valueFransformer(projector.value(at: timeTransformer(time)), timeTransformer(time))
    }

    @discardableResult
    func time(newDuration: Double, transform: @escaping (Double) -> Double) -> Self {
        self.duration = newDuration
        self.timeTransformer = transform

        return self
    }

    @discardableResult
    func transform(_ transform: @escaping (CGFloat) -> CGFloat) -> Self {
        self.valueFransformer = { sourceValue, _ in transform(sourceValue) }

        return self
    }

    @discardableResult
    func transform(_ transform: @escaping (CGFloat, Double) -> CGFloat) -> Self {
        self.valueFransformer = transform

        return self
    }
}

public final class VoidProjector: Projector {
    public let duration: TimeInterval = 0.0
    public func value(at: TimeInterval) -> CGFloat { 0.0 }
}

// MARK: - Timeremap

extension Projector {

    public func delay(_ sec: Double) -> some Projector {
        TransformProjector(source: self)
            .time(newDuration: sec + self.duration)
                { $0 <= sec ? 0 : $0 - sec }
    }

    public func stretch(_ sec: TimeInterval) -> some Projector {
        TransformProjector(source: self)
            .time(newDuration: sec)
                { $0 / sec * self.duration }
    }

    // - Cut

    public func cut(head: TimeInterval = 0, tail: TimeInterval = 0) -> some Projector {
        TransformProjector(source: self)
            .time(newDuration: max(duration - (head + tail), 0.0))
                { max(head, min(duration - tail, $0 + head)) }
    }

    // - Trim

    public func trim(range: ClosedRange<TimeInterval>) -> some Projector {
        TransformProjector(source: self)
            .time(newDuration: range.upperBound - range.lowerBound)
                { max(range.lowerBound, min(range.lowerBound + $0, range.upperBound)) }
    }

    public func trim(head sec: TimeInterval) -> some Projector {
        trim(range: 0...sec)
    }

    public func trim(tail sec: TimeInterval) -> some Projector {
        trim(range: (duration - sec)...duration)
    }

    public func trim(from: TimeInterval, to: TimeInterval) -> some Projector {
        trim(range: from...to)
    }
}

// MARK: - Value

extension Projector {

    public func map(transform: @escaping (CGFloat, Double) -> CGFloat) -> some Projector {
        TransformProjector(source: self)
            .transform(transform)
    }
}

// MARK: - Value expressions

extension Projector {

    public static func +(projector: Self, constant: CGFloat) -> some Projector {
        TransformProjector(source: projector)
            .transform { constant + $0 }
    }

    public static func -(projector: Self, constant: CGFloat) -> some Projector {
        TransformProjector(source: projector)
            .transform { constant - $0 }
    }

    public static func *(projector: Self, multiplier: CGFloat) -> some Projector {
        TransformProjector(source: projector)
            .transform { multiplier * $0 }
    }
}
