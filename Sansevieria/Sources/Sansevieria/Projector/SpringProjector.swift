//
//  SpringProjector.swift
//  Reef2
//

import SwiftUI

public struct Spring {
    public let mass: Double // mass `m`
    public let stiffness: Double // spring constant `k`
    public let damping: Double // damping coefficient `c`

    public init(mass: Double, stiffness: Double, damping: Double) {
        self.mass = mass
        self.stiffness = stiffness
        self.damping = damping
    }

    public var dampingRatio: Double {
        c / ( 2 * sqrt(k * m) )
    }

    public var m: Double { mass }
    public var k: Double { stiffness }
    public var c: Double { damping }
    public var ζ: Double { dampingRatio }
    public var β: Double { c / (2 * m) }
    public var ω: Double { sqrt(k / m) } // natural angular frequency

    public static let defaultSpring = Spring(mass: 4, stiffness: 25, damping: 20)

    public func conflict(velocity: CGFloat) -> SpringProjector{
        SpringProjector(displacement: 0, initialVelocity: velocity, spring: self)
    }
}

public class SpringProjector: Projector {

    let initialVelocity: CGFloat // pixel per second
    let displacement: CGFloat
    public let spring: Spring

    public init(displacement: CGFloat, initialVelocity: CGFloat, spring: Spring) {
        self.initialVelocity = initialVelocity
        self.displacement = displacement

        self.spring = spring
    }

    public func value(at time: TimeInterval) -> CGFloat {
        if ζ == 1.0 {
            return CGFloat((c1 + c2 * time) * pow(e, -β * time))
        } else {
            return CGFloat((c1 * cos(ω * time) + c2 * sin(ω * time)) * pow(e, -β * time))
        }
    }

    var c1: Double { Double(displacement) }
    var c2: Double { (Double(initialVelocity) + β * Double(displacement)) / ω }

    public var ζ: Double { spring.ζ }
    public var β: Double { spring.β }
    public var ω: Double { spring.ω }

    public var duration: TimeInterval {
        π / ω * (ζ == 1.0 ? 1 : 2)
    }
}
