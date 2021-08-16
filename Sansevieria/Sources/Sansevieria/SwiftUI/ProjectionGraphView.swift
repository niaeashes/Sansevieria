//
//  ProjectionGraphView.swift
//

import SwiftUI

public struct ProjectionGraphView: View {
    let projector: Projector
    let steps = 100
    let value: Double?

    var valueRange: Range<CGFloat> {
        let values = (0..<steps)
            .map { projector.duration * TimeInterval($0) / TimeInterval(steps - 1) }
            .map { projector.value(at: $0) }
        return (values.min()!)..<(values.max()!)
    }

    public init(projector: Projector, value: Double? = nil) {
        self.projector = projector
        self.value = value
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                if valueRange.lowerBound < 0.0 {
                    Path { path in
                        let valueRange = valueRange
                        let originY: CGFloat = valueRange.upperBound / (valueRange.upperBound - valueRange.lowerBound) * geometry.size.height
                        path.move(to: CGPoint(x: 0, y: originY))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: originY))
                    }
                    .stroke(Color.secondary, style: StrokeStyle(lineWidth: 1.0, lineCap: .round, lineJoin: .round))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .padding(8)
                }
                Path { path in
                    let duration = projector.duration
                    let valueRange = valueRange
                    let y: (TimeInterval) -> CGFloat = { (time) -> CGFloat in
                        CGFloat(-(projector.value(at: time) - valueRange.upperBound) / (valueRange.upperBound - valueRange.lowerBound)) * geometry.size.height
                    }
                    path.move(to: CGPoint(x: 0, y: y(0)))
                    (0..<steps).forEach { index in
                        let progress: TimeInterval = TimeInterval(index) / TimeInterval(steps - 1)
                        let time: TimeInterval = duration * progress
                        path.addLine(to: CGPoint(x: geometry.size.width * CGFloat(progress), y: y(time)))
                    }
                }
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                .frame(width: geometry.size.width, height: geometry.size.height)
                if let value = value {
                    Path { path in
                        path.move(to: CGPoint(x: geometry.size.width * CGFloat(value), y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width * CGFloat(value), y:  geometry.size.height))
                    }
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [8.0], dashPhase: 0.0))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
