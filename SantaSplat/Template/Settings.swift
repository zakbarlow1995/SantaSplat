//
//  Settings.swift
//  SantaSplat
//
//  Created by Zak Barlow on 10/12/2018.
//  Copyright © 2018 zakbarlow. All rights reserved.
//

import SpriteKit

// Masks
enum PhysicsCategories {
    static let none: UInt32 = 0
    static let santaCategory: UInt32 = 0x1 // 1                  : 001
    static let bucketCategory: UInt32 = 0x1 << 1 // Bitwise shift: 010
    static let deathCategory: UInt32 = 0x1 << 2  //              : 100
}

enum ZPositions {
    static let label: CGFloat = 0
    static let bucket: CGFloat = 1
    static let santa: CGFloat = 2
    static let emitter: CGFloat = 3
}

struct Emitter {
    static let splash = "Splash"
    static let splat = "Splat"
}
