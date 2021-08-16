//
//  DecelerationView.swift
//  SanseveriaExample
//

import SwiftUI
import Sansevieria

struct DecelerationView: View {
    var body: some View {
        CatalogView("Deceleration") {
            PreviewView("v = 200, .normal", DecelerationProjector(initialVelocity: 200, decelerationRate: .normal))
        }
    }
}

struct DecelerationView_Previews: PreviewProvider {
    static var previews: some View {
        DecelerationView()
    }
}
