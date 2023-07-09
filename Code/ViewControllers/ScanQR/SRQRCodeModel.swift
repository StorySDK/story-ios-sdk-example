//
//  SRQRCodeModel.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 09.07.2023.
//

import Foundation

final class SRQRCodeModel {
    
    public func sdkTokenKey(by value: String) -> String {
        guard let url = URL(string: value) else {
            return value
        }
        
        let parts = url.pathComponents
        if parts.count >= 3 {
            return parts[2] // SDK token
        }
        
        return url.lastPathComponent
    }
}
