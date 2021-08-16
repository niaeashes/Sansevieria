//
//  AnyProjector.swift
//

import Foundation
import CoreGraphics

public final class AnyProjector: Projector {
    let projector: Projector

    public init(_ projector: Projector) {
        self.projector = projector
    }

    public var duration: TimeInterval { projector.duration }
    public func value(at time: TimeInterval) -> CGFloat {
        projector.value(at: time)
    }
}

extension Projector {
    public var any: AnyProjector { AnyProjector(self) }
}
