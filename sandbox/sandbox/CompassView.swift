//
//  CompassView.swift
//  Stargazing-iOS
//
//  Created by Adellar Irankunda on 12/4/23.
//

import SwiftUI

struct CompassView: View {
    @Binding var heading: Double 
    let compassDial = Array(stride(from: 0, to: 360, by: 1))
    + Array(stride(from: 0, to: 360, by: 1)) + Array(stride(from: 0, to: 360, by: 1))
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollReader in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 1) {
                        ForEach(compassDial, id: \.self) { degree in
                            
                                CompassDegreeView(degree: degree % 360)
                        }
                    }
                }
                //.setContentOffset()
                //.offset(x: (-1.2 * heading) + 50 )
                //.offset(CGSize(width: -heading, height: 0))
                .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black, .black, .clear]), startPoint: .leading, endPoint: .trailing))
                //.animation(.easeInOut)
                
                
                 .onChange(of: heading) { newHeading in
                     DispatchQueue.main.async {
                         withAnimation(.linear(duration: 0.1)) {
                             //print(Int(newHeading))
                             scrollReader.scrollTo(Int(newHeading), anchor: .leading)
                         }
                     }
                 
                 }
                 
                
            }
            
            Image(systemName: "arrowtriangle.up.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.red)
                .font(.system(size: 10))
        }
    }
}

struct CompassDegreeView: View {
    var degree: Int
    
    var body: some View {
        VStack {
            if degree % 15 != 0
            {
                Rectangle()
                    .frame(width: 0, height: 0)
            }
                else{
                
                
                if degree % 90 == 0 { // Cardinal directions
                    Text(degree == 0 ? "N" : degree == 90 ? "E" : degree == 180 ? "S" : "W")
                        .font(.caption)
                        .foregroundColor(.red)
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 2, height: 20)
                } else {
                    Rectangle()
                        .fill(degree % 45 == 0 ? Color.gray : Color.gray.opacity(0.5))
                        .frame(width: 2, height: degree % 45 == 0 ? 20 : 10)
                }
            }
        }
    }
}


#Preview{
    CompassView(heading: .constant(20))
}

