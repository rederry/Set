//
//  SetCardView.swift
//  Set
//
//  Created by KangKang on 2017/12/10.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class SetBoardView: UIView {

    var cardViews = [SetCardView]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSetCards()
    }
    
    private func layoutSetCards() {
        var grid = Grid(layout: .aspectRatio(Constant.cellAspectRatio), frame: bounds)
        grid.cellCount = cardViews.count
        let cellPadding = Constant.cellPadding
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

extension SetBoardView {
    struct Constant {
        static let cellAspectRatio: CGFloat = 0.7
        static let cellPadding: CGFloat  = 5
    }
}
