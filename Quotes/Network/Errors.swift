//
//  Errors.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation

enum AppError: Error {
    case serverUnreachable
    
    var localizedDescription: String {
        switch self {
        case .serverUnreachable:
            return NSLocalizedString("Server unreachable. Check your connection or try again later", comment: "")
        }
    }
}
