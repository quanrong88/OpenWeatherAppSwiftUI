//
//  View+Navigation.swift
//  OpenWeatherMVVMC
//
//  Created by Tạ Minh Quân on 26/07/2023.
//

import Foundation
import SwiftUI

extension View {
    
    func push<Item, Destination: View>(item: Binding<Item?>, @ViewBuilder destination: @escaping (Item) -> Destination) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        
        return VStack(spacing: 0) {
            self
            
            NavigationLink(
                destination: LazyView(destination(item.wrappedValue!)),
                isActive: isActive,
                label: { EmptyView() }
            )
            .opacity(0)
        }
    }
    
    func present<Item, Destination: View>(item: Binding<Item?>, @ViewBuilder destination: @escaping (Item) -> Destination) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        
        return self.sheet(isPresented: isActive) {
            if let item = item.wrappedValue {
                destination(item)
            } else {
                EmptyView()
            }
        }
    }
}
