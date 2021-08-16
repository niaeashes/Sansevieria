//
//  PreviewView.swift
//  SanseveriaExample
//

import SwiftUI
import Sansevieria

struct PreviewView: View {
    let projector: Projector
    let caption: String

    init(_ caption: String, _ projector: Projector) {
        self.projector = projector
        self.caption = caption
    }

    var body: some View {
        VStack(spacing: 8) {
            ProjectionGraphView(projector: projector)
                .frame(width: 100, height: 100)
            Text(caption)
        }
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView("Preview",  DecelerationProjector(initialVelocity: -200, decelerationRate: .normal))
    }
}
