//
//  ToastView.swift
//  sandbox
//
//  Created by Adellar Irankunda on 12/12/23.
//

import SwiftUI

struct ToastView: View {
    @ObservedObject var skyStatus : SkyStatus
    var statusText : [String] = ["Planetarium", "Hemisphere", "Sky"]
    var toastText: String = "Outdoor Mode"
    @State private var isVisible = false
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .fill(Material.ultraThin)

                Text(statusText[skyStatus.skyMode])
                    .font(.custom("Helvetica Neue", size: 15))
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .frame(width: 150, height: 50)
            .opacity(isVisible ? 1 : 0) // Use the isVisible state for opacity
            .onChange(of: skyStatus.skyMode) { _ in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                    withAnimation {
                        isVisible = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isVisible = false
                    }
                }
            }
        }
}

#Preview {
    ToastView(skyStatus: SkyStatus())
}
