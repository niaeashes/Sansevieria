//
//  Projector.swift
//  Reef2
//

import SwiftUI

let π = Double.pi
let e = M_E

///
/// The Projector maps TimeInterval to Value for UI animation.
///
public protocol Projector {
    /// The value at time (diff from initial value)
    func value(at: TimeInterval) -> CGFloat

    var duration: TimeInterval { get }
}
