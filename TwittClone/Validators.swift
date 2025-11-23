//
//  Validators.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-05.
//

import Foundation

enum Validators{
    
    static func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
}
