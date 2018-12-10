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
    static let santaCategory: UInt32 = 0x1 // 1                  : 01
    static let bucketCategory: UInt32 = 0x1 << 1 // Bitwise shift: 10
}