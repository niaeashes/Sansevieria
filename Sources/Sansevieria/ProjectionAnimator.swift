//
//  ProjectionAnimator.swift
//

import QuartzCore

public final class ProjectionAnimator {

    public typealias Animations = (CGFloat) -> Void

    private let projector: Projector
    private let animations: Animations

    private let firstFrameTimestamp: CFTimeInterval

    public private(set) var running: Bool = true

    public init(_ projector: Projector, animations: @escaping Animations) {
        self.projector = projector
        self.animations = animations

        firstFrameTimestamp = CACurrentMediaTime()
    }

    public func start() {
        #if TARGET_OS_IPHONE
        let displayLink = CADisplayLink(target: self, selector: #selector(handleFrame(_:)))
        displayLink.add(to: .main, forMode: RunLoop.Mode.common)
        self.displayLink = displayLink
        #endif
    }

    #if TARGET_OS_IPHONE

    private weak var displayLink: CADisplayLink? = nil

    @objc private func handleFrame(_ displayLink: CADisplayLink) {
        guard running else { return }
        let elapsed = (CACurrentMediaTime() - firstFrameTimestamp)
        if elapsed <= projector.duration {
            animations(projector.value(at: elapsed))
        } else {
            animations(projector.value(at: projector.duration))
            running = false
            displayLink.invalidate()
        }
    }

    #endif

    deinit {
        invalidate()
    }

    public func invalidate() {
        guard running else { return }
        running = false
        #if TARGET_OS_IPHONE
        displayLink?.invalidate()
        #endif
    }
}
