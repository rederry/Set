//
//  ViewController.swift
//  Set
//
//  Created by KangKang on 2017/12/2.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    var game = SetGame()

    @IBOutlet private weak var player1Button: UIButton!
    @IBOutlet private weak var player2Button: UIButton!
    @IBOutlet private weak var dealButton: UIButton!
    @IBOutlet private weak var deckStackView: UIStackView!
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
    //UIDynamicAnimator
    private lazy var animator : UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: setBoardView)
        animator.delegate = self
        return animator
    }()
    
    private lazy var behavior: CardFlyawayBehavior = {
        let behavior = CardFlyawayBehavior(animator)
        behavior.snapPoint = discardPileCenter
        return behavior
    }()
    
    private var deckCenter: CGPoint {
        let ct = deckStackView.center
//        print("deckStackView center: \(deckStackView.center)")
        let centerOnBoard = view.convert(ct, to: setBoardView)
        setBoardView.deckCenter = centerOnBoard
//        print("centerOnBoard: \(deckStackView.center)")
        
//        let deckView = SetCardView()
//        deckView.frame = CGRect(x: ct.x-35, y: ct.y-50, width: 70, height: 100)
//        view.addSubview(deckView)
//        print("deckView center: \(deckView.center)")
        return centerOnBoard
    }
    private var discardPileCenter: CGPoint {
        return deckCenter
    }

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
        setBoardView.resetCards()
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
    }
    
    @objc func updateViewFromModel() {
        for index in 0..<game.playingCards.count {
            let card = game.playingCards[index]

            if index >= setBoardView.cardViews.count {
                let cardView = createCardView()
                updateCardView(cardView, for: card)
                setBoardView.cardViews.append(cardView)
                setBoardView.addSubview(cardView)
            } else {
                let cardView = setBoardView.cardViews[index]
                updateCardView(cardView, for: card)
                configCardViewState(cardView, card)
            }
        }
        
        // Remove off board card view
        for _ in game.playingCards.count..<setBoardView.cardViews.count {            
            setBoardView.cardViews.removeLast().removeFromSuperview()
        }
        
        // - TODO: Fix deal card animation
        if let matched = game.is3SelectedCardsMatched, matched {
            deal3Cards()
        }
        
        // Update Score Label
        scoreLabel.text = "Score: \(game.score)"
        scoreLabel.text = "Remain: \(game.deckOfCards.count)"
        player1Button.setTitle("Set!(\(game.scoreForPlayer1))", for: .normal)
        player2Button.setTitle("Set!(\(game.scoreForPlayer2))", for: .normal)
        
        if let _ = game.currentPlayer {
            player1Button.isEnabled = false
            player2Button.isEnabled = false
            player1Button.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            player2Button.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        } else {
            player1Button.isEnabled = true
            player2Button.isEnabled = true
            player1Button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            player2Button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
        
        if game.deckOfCards.isEmpty {
            dealButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            dealButton.isEnabled = false
        } else {
            dealButton.setTitleColor(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1), for: .normal)
            dealButton.isEnabled = true
        }
    }
    
    private var tmpCards = [SetCardView]()
    private func configCardViewState(_ cardView: SetCardView, _ card: SetCard) {
        if game.selectedCards.contains(card) {
            cardView.isSelected = true
            cardView.isMatched = game.is3SelectedCardsMatched
            if let matched = game.is3SelectedCardsMatched, matched {
                //- MARK: Flyaway animation
                let tmpCard = cardView.copyCard()
                tmpCards.append(tmpCard)
                setBoardView.addSubview(tmpCard)
                behavior.addItem(tmpCard)
                cardView.alpha = 0
            }
        } else {
            cardView.isSelected = false
            cardView.isMatched = nil
        }
        cardView.configState()
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        tmpCards.forEach { (tmpCard) in
            UIView.transition(with: tmpCard, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
                tmpCard.isFaceup = false
            }, completion: { (isComplete) in
                self.behavior.remove(tmpCard)
                tmpCard.removeFromSuperview()
            })
        }
    }
    
    private func createCardView() -> SetCardView {
        let cardView = SetCardView(behavior)
        let tap = UITapGestureRecognizer(target: self, action: #selector(choseCard))
        cardView.addGestureRecognizer(tap)
        return cardView
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
        
        if let _ = game.currentPlayer { // have a player
            cardView.isUserInteractionEnabled = true
        } else {
            cardView.isUserInteractionEnabled = false
        }
    }
    
}

