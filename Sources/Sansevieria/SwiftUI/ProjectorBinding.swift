//
//  ProjectorBinding.swift
//

import SwiftUI

public class ProjectorBinding {

    public let projector: Projector
    public let value: Binding<CGFloat>
    var animator: ProjectionAnimator? = nil

    public init(_ projector: Projector, value: Binding<CGFloat>) {
        self.projector = projector
        self.value = value
    }

    public func start() -> Self {
        animator = ProjectionAnimator(projector) { [weak self] in
            self?.value.wrappedValue = $0
        }

        #if TARGET_OS_IPHONE
        animator.start()
        #endif

        #if TARGET_OS_OSX
        animator.start()
        #endif

        return self
    }

    public var running: Bool { animator?.running ?? false }
}

extension Projector {

    public func bind(value: Binding<CGFloat>) -> ProjectorBinding {
        ProjectorBinding(self, value: value)
    }
}
