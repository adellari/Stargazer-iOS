//
//  SnapCarousel.swift
//  sandbox
//
//  Created by Adellar Irankunda on 12/16/23.
//

//
//  SnapCarousel.swift
//  prototype5
//
//  Created by xtabbas on 5/7/20.
//  Copyright © 2020 xtadevs. All rights reserved.
//

import SwiftUI

struct SnapCarousel: View {
    @ObservedObject var UIState: CarouselStateModel
    @State private var items = [
        Card(id: 0, name: "infrared-fav"),
        Card(id: 1, name: "halpha-fav"),
        Card(id: 2, name: "optical-fav", toggle: true),
        Card(id: 3, name: "micro-fav")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 15 // or based on geometry.size
            let widthOfHiddenCards: CGFloat = geometry.size.width * 1.38 // Example proportional width
            let cardHeight: CGFloat = geometry.size.height * 0.4
            
            
            
            Canvas {
                Carousel(
                    numberOfItems: CGFloat(items.count),
                    spacing: spacing,
                    widthOfHiddenCards: widthOfHiddenCards,
                    UIState: UIState
                ) {
                    ForEach(items.indices, id: \.self) { index in
                        var item = items[index]
                        
                        Item(
                            _id: Int(item.id),
                            spacing: spacing,
                            widthOfHiddenCards: widthOfHiddenCards,
                            cardHeight: cardHeight,
                            UIState: UIState
                        ) {
                            ZStack{
                                Image(item.name)
                                    .resizable()
                                    .clipShape(Circle())
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 5))
                                Circle()
                                //.fill(Color.white.opacity(0))
                                
                                    .stroke(item.toggle ? Color.orange : Color.gray, lineWidth: 2)
                                
                            }
                            //.padding(.leading, -100.34)
                            
                        }
                        .background(Circle().fill(Material.thin))
                        .shadow(color: .gray, radius: 4)
                        .transition(AnyTransition.slide)
                        .animation(.spring())
                        .onTapGesture{
                            items[index].toggle.toggle()
                            item.toggle.toggle()
                            
                            #if !targetEnvironment(simulator)
                            UnityBridge.getInstance().api.toggleWavelength(Int32(item.id))
                            
                            #endif
                            
                            print("tapped \(item.name)")
                            //print("toggle \(item.toggle)")
                        }
                    }
                    //.offset(x: UIScreen.main.bounds.width * 0.8)
                    
                    
                }
                
                .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black, .black, .clear]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width / 4))
                //.offset(x: UIScreen.main.bounds.width / 3)
            }
            //.frame(width:UIScreen.main.bounds.)
        }
    }
}

struct Card: Decodable, Hashable, Identifiable {
    var id: Int
    var name: String = ""
    var toggle: Bool = false
    var wavelength: String = ""
}

public class UIStateModel: ObservableObject {
    @Published var activeCard: Int = 2
    @Published var screenDrag: Float = 0.0
}

struct Carousel<Items : View> : View {
    let items: Items
    let numberOfItems: CGFloat //= 8
    let spacing: CGFloat //= 16
    let widthOfHiddenCards: CGFloat //= 32
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    
    @GestureState var isDetectingLongPress = false
    
    @ObservedObject var UIState: CarouselStateModel
    
    @inlinable public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        UIState: CarouselStateModel,
        @ViewBuilder _ items: () -> Items) {
            
            self.items = items()
            self.numberOfItems = numberOfItems
            self.spacing = spacing
            self.widthOfHiddenCards = widthOfHiddenCards
            self.totalSpacing = (numberOfItems - 1) * spacing
            self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
            self.UIState = UIState
            
        }
    
    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 1
        let leftPadding = (widthOfHiddenCards + spacing)
        let totalMovement = (cardWidth + spacing)
        
        let activeOffset = (xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard))) * 0.27
        let nextOffset = (xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard) + 1))
        
        var calcOffset = Float(activeOffset)
        
        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + UIState.screenDrag
        }
        
        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.UIState.screenDrag = Float(currentState.translation.width)
            
        }.onEnded { value in
            self.UIState.screenDrag = 0
            
            if (value.translation.width < -10) {
                self.UIState.activeCard = self.UIState.activeCard + 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            
            if (value.translation.width > 10) {
                self.UIState.activeCard = self.UIState.activeCard - 1
                let impactLight = UIImpactFeedbackGenerator(style: .light)
                impactLight.impactOccurred()
            }
        })
    }
}

struct Canvas<Content : View> : View {
    let content: Content
    @EnvironmentObject var UIState: UIStateModel
    
    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        //.background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct Item<Content: View>: View {
    @ObservedObject var UIState: CarouselStateModel
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    var _id: Int
    var content: Content
    @inlinable public init(
        _id: Int,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardHeight: CGFloat,
        UIState: CarouselStateModel,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
        self.cardHeight = cardHeight
        self.UIState = UIState
        self._id = _id
    }
    
    var body: some View {
        content
            .frame(width: cardWidth / 5, height: _id == UIState.activeCard ? cardHeight * 1.1 : cardHeight * 1.1, alignment: .center)
            
    }
}

#Preview {
    SnapCarousel(UIState: CarouselStateModel())//.environmentObject(UIStateModel())
        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.2)
}
