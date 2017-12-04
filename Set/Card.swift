//
//  Card.swift
//  Set
//
//  Created by KangKang on 2017/12/2.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

struct Card {
    
    let count: CardCount
    let color: CardColor
    let shape: CardShape
    let grain: CardGrain
    
    enum CardCount: Int {
        case countA=1, countB, countC
        static let allValues = [countA, countB, countC]
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
    
}
