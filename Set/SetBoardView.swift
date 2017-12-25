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
    
    func animateDealCard(from point: CGPoint) {
//        isAnimateDealCard = true
        deckCenter = point
    }
    
    private var deckCenter = CGPoint.zero
//    private var isAnimateDealCard = false
    
    func resetCards() {
        cardViews.forEach { $0.alpha = 0 }
        layoutSetCards()
    }
    
//    func updateCardViews() {
//        for index in 0..<game.playingCards.count {
//            let card = game.playingCards[index]
//            
//            if index >= setBoardView.cardViews.count {
//                let cardView = createCardView()
//                updateCardView(cardView, for: card)
//                setBoardView.cardViews.append(cardView)
//                setBoardView.addSubview(cardView)
//            } else {
//                let cardView = setBoardView.cardViews[index]
//                updateCardView(cardView, for: card)
//                configCardViewState(cardView, card)
//            }
//        }
//        
//        // Remove off board card view
//        for _ in game.playingCards.count..<setBoardView.cardViews.count {
//            setBoardView.cardViews.removeLast().removeFromSuperview()
//        }
//        
//        if let matched = game.is3SelectedCardsMatched, matched {
//            deal3Cards()
//        } else {
//            setBoardView.animateDealCard(from: deckCenter)
//        }
//    }

    
    private func layoutSetCards() {
        var grid = Grid(layout: .aspectRatio(Constant.cellAspectRatio), frame: bounds)
        grid.cellCount = cardViews.count
        let cellPadding = Constant.cellPadding
        for index in 0..<grid.cellCount {
            if let frame = grid[index] {
                let cardFrame = CGRect(x: frame.origin.x, y: frame.origin.y,
                                       width: frame.width - cellPadding,
                                       height: frame.height - cellPadding)
                let setCardView = cardViews[index]
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                    setCardView.frame = cardFrame
                }, completion: { position in
                    if setCardView.alpha == 0{
                        setCardView.animateDeal(from: self.deckCenter)
                    }
                })
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
