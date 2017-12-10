//
//  SetCardView.swift
//  Set
//
//  Created by KangKang on 2017/12/10.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class SetBoardView: UIView {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    private func setupCards() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init from code")
        setupCards()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init from storyboard")
        setupCards()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake from Nib")
    }


}
