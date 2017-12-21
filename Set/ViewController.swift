//
//  ViewController.swift
//  Set
//
//  Created by KangKang on 2017/12/2.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = SetGame()

    @IBOutlet weak var dealStackView: UIStackView!
    @IBOutlet weak var player1Button: UIButton!
    @IBOutlet weak var player2Button: UIButton!
    @IBOutlet private weak var dealButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var setBoardView: SetBoardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(deal3Cards))
            swipe.direction = .down
            setBoardView.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(reshuffle))
            setBoardView.addGestureRecognizer(rotate)
        }
    }
    
    private var deckFrame: CGRect {
        return CGRect(x: dealStackView.center.x, y: dealStackView.center.y, width: setBoardView.cardViews[0].bounds.size.width, height: setBoardView.cardViews[0].bounds.size.height)
    }
    
    private lazy var animator = UIDynamicAnimator(referenceView: setBoardView)
    private lazy var collisionBehavior: UICollisionBehavior = {
       let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(behavior)
        return behavior
    }()
    private lazy var itemBehavior: UIDynamicItemBehavior = {
       let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        animator.addBehavior(behavior)
        return behavior
    }()

    @IBAction func player1TouchSet(_ sender: UIButton) {
        game.setTurn(for: .player1)
        updateViewFromModel()
    }
    @IBAction func player2TouchSet(_ sender: UIButton) {
        game.setTurn(for: .player2)
        updateViewFromModel()
    }
    
    @IBAction private func resetGame(_ sender: UIButton) {
        game.resetGame()
        updateViewFromModel()
    }
    
    @IBAction func cheat(_ sender: UIButton) {
        game.cheat()
        updateViewFromModel()
    }
    
    @IBAction func touchDealCardsButton(_ sender: UIButton) {
        deal3Cards()
    }
    
    @objc func deal3Cards() {
        if !game.deckOfCards.isEmpty {
            game.deal3Cards()
            updateViewFromModel()
        }
    }
    
    @objc func reshuffle(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shufflePlayingCards()
            updateViewFromModel()
        default:
            break
        }
    }
    
    @objc func choseCard(_ sender: UITapGestureRecognizer) {
        if let cardView = sender.view as? SetCardView, let cardIndex = setBoardView.cardViews.index(of: cardView) {
            game.selectCard(at: cardIndex)
            updateViewFromModel()
        } else {
            print("Error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewFromModel), name: NSNotification.Name(rawValue: game.playerTurnDidFinishNotification), object: nil)
        
//        print("x: \(dealButton.frame.maxX), y: \(dealButton.frame.maxY),")
//        print("x: \(dealStackView.frame.maxX), y: \(dealStackView.frame.maxY),")
    }
    
    @objc func updateViewFromModel() {
        
        for index in 0..<game.playingCards.count {
            let card = game.playingCards[index]

            var cardView: SetCardView
            if index >= setBoardView.cardViews.count {
                cardView = createCardView()
                updateCardView(cardView, for: card)
                setBoardView.cardViews.append(cardView)
                setBoardView.addSubview(cardView)
            } else {
                cardView = setBoardView.cardViews[index]
                updateCardView(cardView, for: card)
                configCardViewState(cardView, card)
            }
        }
        
        // Remove off board card view
        for _ in game.playingCards.count..<setBoardView.cardViews.count {            
            setBoardView.cardViews.removeLast().removeFromSuperview()
        }
        
        if let matched = game.is3SelectedCardsMatched, matched {
        } else {
            // Rearrange first
            // - MARK: Placeholder for deal a card animation
            setBoardView.setNeedsLayout()
            for cardView in setBoardView.cardViews {
                if cardView.alpha == 0 {
                    let currentFrame = cardView.frame
                    cardView.frame = self.deckFrame
                    cardView.alpha = 1
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: Constants.cardDisappearTime, delay: 0.5, options: [], animations: {
                        cardView.frame = currentFrame
                    }, completion: nil)
                }
            }
        }
        
        // Update Score Label
        scoreLabel.text = "Score: \(game.score)"
        scoreLabel.text = "Remain: \(game.deckOfCards.count)"
        player1Button.setTitle("Set!(\(game.scoreForPlayer1))", for: .normal)
        player2Button.setTitle("Set!(\(game.scoreForPlayer2))", for: .normal)
        
        if let _ = game.currentPlayer {
            player1Button.isEnabled = false
            player2Button.isEnabled = false
            player1Button.setTitleColor(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), for: .normal)
            player2Button.setTitleColor(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), for: .normal)
        } else {
            player1Button.isEnabled = true
            player2Button.isEnabled = true
            player1Button.setTitleColor(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1), for: .normal)
            player2Button.setTitleColor(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1), for: .normal)
        }
        
        if game.deckOfCards.isEmpty {
            dealButton.setTitleColor(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), for: .normal)
            dealButton.isEnabled = false
        } else {
            dealButton.setTitleColor(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1), for: .normal)
            dealButton.isEnabled = true
        }
    }
    
    private func configCardViewState(_ cardView: SetCardView, _ card: SetCard) {
        cardView.layer.cornerRadius = cardView.cornerRadius
        cardView.layer.borderWidth = cardView.patternLineWidth*2
        cardView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        cardView.isUserInteractionEnabled = true
        if game.selectedCards.contains(card) { // highlight selected card view
            cardView.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1).cgColor
            if let matched = game.is3SelectedCardsMatched { // Already selected 3 cards
                if matched {
                    cardView.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1).cgColor
                    cardView.isUserInteractionEnabled = false
                    //- MARK: Placeholder for flyaway animation
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: Constants.cardDisappearTime, delay: 1, options: [], animations: {
                        cardView.alpha = 0
                    }, completion: nil)
                    collisionBehavior.addItem(cardView)
                    itemBehavior.addItem(cardView)
                    let pushBehavior = UIPushBehavior(items: [cardView], mode: .instantaneous)
                    pushBehavior.magnitude = 1.0 + CGFloat(2.0).arc4random
                    pushBehavior.angle = (2*CGFloat.pi).arc4random
                    pushBehavior.action = { [unowned pushBehavior] in
                        pushBehavior.dynamicAnimator?.removeBehavior(pushBehavior)
                    }
                    pushBehavior.addItem(cardView)
                    animator.addBehavior(pushBehavior)
                } else {
                    cardView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
                    collisionBehavior.removeItem(cardView)
                    itemBehavior.removeItem(cardView)
                }
            }
        } else {
            collisionBehavior.removeItem(cardView)
            itemBehavior.removeItem(cardView)
            cardView.layer.borderWidth = 0
        }
    }
    
    /// Update the card view use a card model
    private func updateCardView(_ cardView: SetCardView, for card: SetCard) {
        let count = card.count.rawValue
        let color: UIColor
        let shape: SetCardView.Shape
        let grain: SetCardView.Grain
        switch card.color {
        case .colorA:
            color = #colorLiteral(red: 0.07843137255, green: 0.6078431373, blue: 0.2666666667, alpha: 1)
        case .colorB:
            color = #colorLiteral(red: 0.8196078431, green: 0.1411764706, blue: 0.1960784314, alpha: 1)
        case .colorC:
            color = #colorLiteral(red: 0.1764705882, green: 0.1137254902, blue: 0.3960784314, alpha: 1)
        }
        switch card.shape {
        case .shapeA:
            shape = .diamond
        case .shapeB:
            shape = .oval
        case .shapeC:
            shape = .squiggle
        }
        switch card.grain {
        case .grainA:
            grain = .outlined
        case .grainB:
            grain = .solid
        case .grainC:
            grain = .striped
        }
        
        if cardView.count != count {
            cardView.count = count
        }
        if cardView.color != color {
            cardView.color = color
        }
        if cardView.shape != shape {
            cardView.shape = shape
        }
        if cardView.grain != grain {
            cardView.grain = grain
        }
        
//        if let _ = game.currentPlayer { // have a player
//            cardView.isUserInteractionEnabled = true
//        } else {
//            cardView.isUserInteractionEnabled = false
//        }
    }
    
    private func createCardView() -> SetCardView {
        let cardView = SetCardView()
//        cardView.frame = CGRect(x: dealStackView.frame.minX, y: dealStackView.frame.minY, width: 0, height: 0)
        cardView.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(choseCard))
        cardView.addGestureRecognizer(tap)
        return cardView
    }
}

extension ViewController {
    struct Constants {
        static let cardDisappearTime: TimeInterval = 1
        static let cardDealTime: TimeInterval = 1
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
        return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

