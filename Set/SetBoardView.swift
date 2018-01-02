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
    
    var deckCenter = CGPoint.zero
    
    func resetCards() {
        cardViews.forEach { $0.alpha = 0 }
        layoutSetCards()
    }
    
    private func layoutSetCards() {
        var grid = Grid(layout: .aspectRatio(Constant.cellAspectRatio), frame: bounds)
        grid.cellCount = cardViews.count
        for index in 0..<grid.cellCount {
            if let frame = grid[index] {
                let cellPadding = Constant.cellPaddingToBoundsWidth * frame.width
                let cardFrame = CGRect(x: frame.origin.x, y: frame.origin.y,
                                       width: frame.width - cellPadding,
                                       height: frame.height - cellPadding)
                let setCardView = cardViews[index]
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                    setCardView.frame = cardFrame
                })
//                    , completion: { position in
//                    if setCardView.alpha == 0{
//                        setCardView.animateDeal(from: self.deckCenter)
//                    }
//                })
            }
        }
    }
}

extension SetBoardView {
    struct Constant {
        static let cellAspectRatio: CGFloat = 0.7
        static let cellPaddingToBoundsWidth: CGFloat  = 1/20
    }
}
