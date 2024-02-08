//
//  UnityAPI.swift
//  sandbox
//
//  Created by Adellar Irankunda on 12/9/23.
//

import SwiftUI
#if targetEnvironment(simulator)

#else


class UnityAPI: NativeCallsProtocol {

    internal weak var bridge: UnityBridge!
    public var deg: CGFloat = 0
    
    /**
        Function pointers to static functions declared in Unity
     */
    
    private var testCallback: TestDelegate?
    private var projectionCallback: ProjectionDelegate?
    private var wavelengthCallback: WavelengthDelegate?
    
    /**
        Public API
     */
    
    public func test(_ value: String, len: Int) {
        self.testCallback?(value, Int32(len))
    }
    
    public func setProjection(_ flag: Int32) {
        self.projectionCallback?(flag)
    }
    
    public func toggleWavelength(_ flag: Int32) {
        self.wavelengthCallback?(flag)
    }
    
    /**
        Internal methods are called by Unity
     */
    
    internal func onCompassUpdate(_ compassVal: Float32) {
        //print("compass value received: ",compassVal)
        deg = CGFloat(compassVal);
    }
    
    internal func onUnityStateChange(_ state: String) {
        switch (state) {
        case "ready":
            self.bridge.onReady()
        default:
            return
        }
    }
    
    internal func onSetTestDelegate(_ delegate: TestDelegate!) {
        self.testCallback = delegate
    }
    
    internal func onSetProjectionDelegate(_ delegate: ProjectionDelegate!){
        self.projectionCallback = delegate
    }
    
    internal func onSetWavelengthDelegate(_ delegate: WavelengthDelegate!){
        self.wavelengthCallback = delegate
    }
    
}
#endif
