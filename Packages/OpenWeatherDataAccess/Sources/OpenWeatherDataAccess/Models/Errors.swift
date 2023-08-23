//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 14/05/2023.
//

import Foundation

public enum AppError: LocalizedError {
    case locationNotFound
    case network(Error)
    
    public var errorDescription: String? {
        switch self {
        case .locationNotFound:
            return "Location is not found"
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
