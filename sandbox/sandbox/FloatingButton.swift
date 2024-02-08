//
//  FloatingButton.swift
//  sandbox
//
//  Created by Adellar Irankunda on 12/8/23.
//

import SwiftUI

import SwiftUI

struct FloatingActionButton: View {
    @ObservedObject var skyStatus : SkyStatus
    @State private var isExpanded = false
    let buttonsCount = 3 // The total number of secondary buttons
    let radius: CGFloat = 60 // The radius of the circular pattern
    let overlays = ["sky-full", "sky-half", "sky-segment-half"]
    
    var body: some View {
        ZStack {
            ForEach(0..<buttonsCount, id: \.self) { index in
                Button(action: { 
                    skyStatus.skyMode = Int(index)
                    print("Option \(index)")
                    #if !targetEnvironment(simulator)
                    UnityBridge.getInstance().api.setProjection(Int32(index))
                    #endif
                    }) {
                        
                    Image(overlays[index])
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Material.thin))
                        .clipShape(Circle())
                    
                        .foregroundColor(.gray)
                        .shadow(radius: 2)
                        
                }
                .offset(x: isExpanded ? -cos(CGFloat(index) * .pi / CGFloat(buttonsCount + 1)) * radius : 0,
                        y: isExpanded ? -sin(CGFloat(index) * .pi / CGFloat(buttonsCount + 1)) * radius : 0)
                .opacity(isExpanded ? 1 : 0)
            }
            
            Button(action: toggle) {
                Image(systemName: isExpanded ? "eye.fill" : "eye")
                //.resizable()
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(Material.thick))
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                    .shadow(radius: 5)
            }
        }
        .animation(.default, value: isExpanded)
        

    }
    
    func toggle() {
        isExpanded.toggle()
    }
}



#Preview {
    FloatingActionButton(skyStatus: SkyStatus())
}
