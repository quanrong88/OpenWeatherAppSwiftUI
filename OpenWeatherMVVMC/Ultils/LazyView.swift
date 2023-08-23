//
//  LazyView.swift
//  OpenWeatherMVVMC
//
//  Created by Tạ Minh Quân on 26/07/2023.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    
    let contentBuilder: () -> Content
    
    init(_ contentBuilder: @autoclosure @escaping () -> Content) {
        self.contentBuilder = contentBuilder
    }
    
    var body: Content {
        contentBuilder()
    }
}
