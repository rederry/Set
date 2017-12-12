//
//  SetCardView.swift
//  Set
//
//  Created by KangKang on 2017/12/10.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class SetBoardView: UIView {

    var setCardViews = [SetCardView]() { didSet { setNeedsDisplay(); setNeedsLayout() } }
    let defaultCardCount = 12
    
    private func setupCards() {
        for _ in 0..<defaultCardCount {
            let setCardView = SetCardView()
            setCardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            setCardView.isOpaque = true
            setCardViews.append(setCardView)
            addSubview(setCardView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCards()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCards()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSetCards()
    }
    
    private func layoutSetCards() {
        var grid = Grid(layout: .aspectRatio(0.7), frame: bounds)
        grid.cellCount = setCardViews.count
        let cellPadding: CGFloat = 5
        for index in 0..<grid.cellCount {
            if let frame = grid[index] {
                let cardFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width - cellPadding,
                                       height: frame.height - cellPadding)
                let setCardView = setCardViews[index]
                setCardView.frame = cardFrame
            }
        }
    }

}
