//
//  helperSwift.swift
//  Diodon
//
//  Created by Ambroise COLLON on 20/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

extension Int {
    static func random(upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperBound)))
    }

    static func maximum(_ a: Int, _ b: Int) -> Int{
        return a < b ? b : a
    }

    static func minimum(_ a: Int, _ b: Int) -> Int{
        return a < b ? a : b
    }

}
