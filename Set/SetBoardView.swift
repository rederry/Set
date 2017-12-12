//
//  SetCardView.swift
//  Set
//
//  Created by KangKang on 2017/12/10.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class SetBoardView: UIView {

    var cardViews = [SetCardView]() {
        willSet {
            cardViews.forEach{$0.removeFromSuperview()}
            newValue.forEach{addSubview($0)}
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSetCards()
    }
    
    private func layoutSetCards() {
        var grid = Grid(layout: .aspectRatio(0.7), frame: bounds)
        grid.cellCount = cardViews.count
        let cellPadding: CGFloat = 5
        for index in 0..<grid.cellCount {
            if let frame = grid[index] {
                let cardFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width - cellPadding,
                                       height: frame.height - cellPadding)
                let setCardView = cardViews[index]
                setCardView.frame = cardFrame
            }
        }
    }

}
