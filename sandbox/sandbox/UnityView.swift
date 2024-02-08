import SwiftUI

#if targetEnvironment(simulator)

struct UnityView: View {
    var body: some View{
        Rectangle()
    }
}

#else


struct UnityView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()

        //UnityBridge.getInstance().superview = vc.view
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            UnityBridge.getInstance().superview = vc.view
        }
        UnityBridge.getInstance().onReady = {
            print("Unity is now ready!")
            UnityBridge.getInstance().api.test("This string travels far, far away toward Unity", len: 34)
        }

        return vc
    }

    func updateUIViewController(_ viewController: UIViewController, context: Context) {}
}


#endif

#Preview {
    UnityView()
}
