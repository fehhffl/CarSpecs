//
//  RandomNumberGenerator.swift
//  Backend
//
//  Created by Gabriel Carvalho on 23/09/23.
//

import Foundation

// A number generator that always generates the same random numbers
class FixedRandomNumberGenerator: RandomNumberGenerator {
    init() {
        // Set the same seed everytime so we
        // get the same shuffle for the cars
        srand48(1)
    }

    public func next() -> UInt64 {
        UInt64(drand48() * 0x1.0p64) ^ UInt64(drand48() * 0x1.0p16)
    }
}
