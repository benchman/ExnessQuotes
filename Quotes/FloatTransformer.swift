//
//  FloatTransformer.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation
import ObjectMapper

class FloatTransformer: TransformType {
    func transformToJSON(_ value: Float?) -> String? {
        if let double = value {
            return "\(double)"
        }
        return nil
    }
    
    func transformFromJSON(_ value: Any?) -> Float? {
        if let string = value as? String {
            return Float(string)
        }
        return nil
    }
}
