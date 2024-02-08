//
//  DataHandlers.swift
//  sandbox
//
//  Created by Adellar Irankunda on 12/12/23.
//

import SwiftUI
import Combine

@MainActor
public class SkyStatus: ObservableObject{
    @Published var skyMode: Int = 2
    @Published var wavelength: Int = 0
}

@MainActor
public class CarouselStateModel: ObservableObject{
    @Published var activeCard: Int = 2
    @Published var screenDrag: Float = 0
}

public class PointingStatus: ObservableObject{
    @Published var heading: Int = 0
    @Published var focus: String = "none"
}
