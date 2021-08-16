//
//  SinusoidalCatalogView.swift
//  SanseveriaExample
//

import SwiftUI
import Sansevieria

struct SinusoidalCatalogView: View {
    var body: some View {
        CatalogView("Sinusoidal") {
            PreviewView("Ease In", FormulaProjector.sinusoidal.easeIn)
            PreviewView("Ease Out", FormulaProjector.sinusoidal.easeOut)
            PreviewView("Ease In Out", FormulaProjector.sinusoidal.easeInOut)
        }
    }
}

struct SinusoidalCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        SinusoidalCatalogView()
    }
}
