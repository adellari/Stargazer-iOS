//
//  ContentView.swift
//  sandbox
//
//  Created by David Peicho on 1/21/21.
//

import SwiftUI

#if targetEnvironment(simulator)

#else
struct OtherUnityView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            UnityBridge.getInstance().superview = vc.view
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            UnityBridge.getInstance().superview = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 11.0) {
            UnityBridge.getInstance().superview = vc.view
        }

        return vc
    }

    func updateUIViewController(_ viewController: UIViewController, context: Context) {}
}
#endif

struct ContentView: View {
    @State private var heading: Double = 0
    @ObservedObject var skyStatus = SkyStatus()
    @ObservedObject var CarouselState = CarouselStateModel()
    
    var body: some View {
        ZStack {
            
            

            #if targetEnvironment(simulator)
            
            #else
            UnityView()
                .ignoresSafeArea()
            /*
            Button("This button overlaps Unity!", action: {
                UnityBridge.getInstance().api.test("Native button pressed!", len:34)
            }).buttonStyle(.borderedProminent).tint(.blue)
            */
#endif
            VStack{
                ToastView(skyStatus: skyStatus)
                    .offset(x: 0, y: UIScreen.main.bounds.height * -0.25)
                
                SnapCarousel(UIState: CarouselState)//.environmentObject(UIStateModel())
                    .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height * 0.15)
                    .offset(x: UIScreen.main.bounds.width * 0.34)
                
                FloatingActionButton(skyStatus: skyStatus)
                    .offset(x: UIScreen.main.bounds.width / 2.8, y: UIScreen.main.bounds.height / 4)
                
                CompassView(heading:  $heading).ignoresSafeArea()
                    .offset(x: 0, y: UIScreen.main.bounds.height * 0.28)
                
            }
            
        }.onAppear{
            
            #if !targetEnvironment(simulator)
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ _ in
                self.heading = Double(UnityBridge.getInstance().api.deg)
            }
            #endif
        }
        
    }
        
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
