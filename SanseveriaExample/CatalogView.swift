//
//  CatalogView.swift
//  SanseveriaExample
//

import SwiftUI

struct CatalogView<Content: View>: View {
    let title: String
    let content: () -> Content

    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .bold()
                .font(.headline)
            HStack(spacing: 16) {
                content()
            }
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView("Sample") {
            Text("Sample")
        }
    }
}
