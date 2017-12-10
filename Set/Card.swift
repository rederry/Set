//
//  Card.swift
//  Set
//
//  Created by KangKang on 2017/12/2.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    let count: CardCount
    let color: CardColor
    let shape: CardShape
    let grain: CardGrain
    
    enum CardCount: Int {
        case count1=1, count2, count3
        static let allValues = [count1, count2, count3]
    }
    
    enum CardColor {
        case colorA, colorB, colorC
        static let allValues = [colorA, colorB, colorC]
    }
    
    enum CardShape {
        case shapeA, shapeB, shapeC
        static let allValues = [shapeA, shapeB, shapeC]
    }
    
    enum CardGrain {
        case grainA, grainB, grainC
        static let allValues = [grainA, grainB, grainC]
    }
    
    init(count: CardCount, color: CardColor, shape: CardShape, grain: CardGrain) {
        self.count = count
        self.color = color
        self.shape = shape
        self.grain = grain
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.count == rhs.count && lhs.color == rhs.color
            && lhs.shape == rhs.shape && lhs.grain == rhs.grain
    }
    
}
