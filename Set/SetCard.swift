//
//  Card.swift
//  Set
//
//  Created by KangKang on 2017/12/2.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

/// An individual set game card
struct SetCard: Equatable {
    
    let count: Count
    let color: Color
    let shape: Shape
    let grain: Grain
    
    enum Count: Int {
        case count1=1, count2, count3
        static let allValues = [count1, count2, count3]
    }
    
    enum Color {
        case colorA, colorB, colorC
        static let allValues = [colorA, colorB, colorC]
    }
    
    enum Shape {
        case shapeA, shapeB, shapeC
        static let allValues = [shapeA, shapeB, shapeC]
    }
    
    enum Grain {
        case grainA, grainB, grainC
        static let allValues = [grainA, grainB, grainC]
    }
    
    init(count: Count, color: Color, shape: Shape, grain: Grain) {
        self.count = count
        self.color = color
        self.shape = shape
        self.grain = grain
    }
    
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return lhs.count == rhs.count && lhs.color == rhs.color
            && lhs.shape == rhs.shape && lhs.grain == rhs.grain
    }
    
}
