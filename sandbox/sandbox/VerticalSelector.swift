//
//  VerticalSelector.swift
//  sandbox
//
//  Created by Adellar Irankunda on 12/16/23.
//

import SwiftUI

import SwiftUI

struct VerticalSelector: View {
    var body: some View {
        SnapToCenterScrollView()
    }
}

struct SnapToCenterScrollView: View {
    let items = Array(0..<10)
    @State private var currentSelection: Int = 0

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    ForEach(items, id: \.self) { item in
                        Circle()
                            .fill(item % 2 == 0 ? Color.blue : Color.green)
                            .frame(width: 100, height: 100)
                            .overlay(Text("\(item)"))
                            .id(item)
                    }
                }
                .modifier(SnapToCenterModifier(currentSelection: $currentSelection, fullViewSize: fullView.size))
            }
        }
    }
}

///Packages/com.github.homuler.mediapipe/
//Packages/com.github.homuler.mediapipe/Runtime/

struct SnapToCenterModifier: ViewModifier {
    @Binding var currentSelection: Int
    let fullViewSize: CGSize
    @State private var dragOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(y: self.dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.dragOffset = value.translation.height
                    }
                    .onEnded { value in
                        self.dragOffset = 0

                        // Calculate new offset after drag
                        let predictedEndOffset = self.scrollOffset + value.predictedEndTranslation.height
                        self.updateScrollOffset(predictedEndOffset)
                    }
            )
            .onPreferenceChange(ViewOffsetKey.self) { preferences in
                self.updateScrollOffset(self.scrollOffset, preferences: preferences)
            }
            .frame(width: fullViewSize.width, height: fullViewSize.height)
    }

    private func updateScrollOffset(_ newOffset: CGFloat, preferences: [ViewOffsetPreferenceData] = []) {
        let center = fullViewSize.height / 2
        var closest = CGFloat.infinity
        var selectedId = currentSelection

        for preference in preferences {
            let distance = abs(preference.center.y + newOffset - center)
            if distance < closest {
                closest = distance
                selectedId = preference.id
            }
        }

        withAnimation {
            self.scrollOffset = newOffset
            self.currentSelection = selectedId
        }
    }
}

struct ViewOffsetPreferenceData : Equatable {
    let id: Int
    let center: CGPoint
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: [ViewOffsetPreferenceData] = []

    static func reduce(value: inout [ViewOffsetPreferenceData], nextValue: () -> [ViewOffsetPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}


#Preview {
    VerticalSelector()
}
