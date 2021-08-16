//
//  ContentView.swift
//  SanseveriaExample
//

import SwiftUI
import Sansevieria

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            DecelerationView()
            SinusoidalCatalogView()
        }
        .padding(16)
    }
}

struct ProjectionView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()

        ProjectionGraphView(projector: DecelerationProjector(from: 300, to: -1000).bounse(at: 0, current: 300))

        ProjectionGraphView(projector: DecelerationProjector(from: 700, to: 1700).bounse(at: 1000, current: 700))
    }
}
