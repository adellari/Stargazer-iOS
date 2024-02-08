//
//  LazyCompassView.swift
//  sandbox
//
//  Created by Adellar Irankunda on 12/8/23.
//

import SwiftUI

struct LazyCompassView: View {
    @State private var heading: Double = 0 // Replace with your heading data source

    let compassDegrees = Array(0..<360) // Array representing each degree

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                // Loop over the compass degrees twice for the illusion of infinite scroll
                ForEach((compassDegrees + compassDegrees), id: \.self) { degree in
                    CompassDegreeView(degree: degree % 360)
                }
            }
            
        }
        .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black, .black, .clear]), startPoint: .leading, endPoint: .trailing))
        .animation(.easeInOut, value: heading)
        .onAppear {
            // Start receiving heading updates from your API
        }
    }
}

struct LazyCompassDegreeView: View {
    let degree: Int

    var body: some View {
        // Customize this view to display the degree markers and cardinal points
        Text("\(degree)°")
    }
}


#Preview {
    LazyCompassView()
}
