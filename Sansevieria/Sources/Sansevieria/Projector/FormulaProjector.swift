//
//  FormulaProjector.swift
//  

import SwiftUI

public final class FormulaProjector: Projector {

    let formula: (Double) -> CGFloat

    // FormulaProjector is 1.0 sec projector that has value between 0 to 1.
    init(formula: @escaping (Double) -> CGFloat) {
        self.formula = formula
    }

    public func value(at time: TimeInterval) -> CGFloat {
        if time <= 0 { return 0 }
        if time >= duration { return 1 }
        return formula(time / duration)
    }

    public let duration: TimeInterval = 1.0

    public static var linear: FormulaProjector { FormulaProjector() { CGFloat($0) } }

    public struct EasingPackage {
        let _easeIn: (Double) -> CGFloat
        let _easeOut: (Double) -> CGFloat
        let _easeInOut: (Double) -> CGFloat

        public var easeIn: FormulaProjector { FormulaProjector(formula: _easeIn) }
        public var easeOut: FormulaProjector { FormulaProjector(formula: _easeOut) }
        public var easeInOut: FormulaProjector { FormulaProjector(formula: _easeInOut) }
    }

    public static var cubic: EasingPackage {
        EasingPackage(
            _easeIn: { CGFloat(pow($0, 3)) },
            _easeOut: { CGFloat(1.0 - pow(1.0 - $0, 3)) },
            _easeInOut: {
                if $0 < 0.5 {
                    return CGFloat(4 * pow($0, 3))
                } else {
                    return CGFloat(1 - pow(-2 * $0 + 2, 3) / 2)
                }
            })
    }

    public static var sinusoidal: EasingPackage {
        EasingPackage(
            _easeIn: { CGFloat(-cos($0 * π / 2.0) + 1) },
            _easeOut: { CGFloat(sin($0 * π / 2.0)) },
            _easeInOut: { CGFloat(-0.5 * (cos(π * $0) - 1)) })
    }
}
