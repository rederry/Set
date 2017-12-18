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

    @IBOutlet weak var player1Button: UIButton!
    @IBOutlet weak var player2Button: UIButton!
    @IBOutlet private weak var dealButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var setBoardView: SetBoardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealCards))
            swipe.direction = .down
            setBoardView.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(reshuffle))
            setBoardView.addGestureRecognizer(rotate)
        }
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
        updateViewFromModel()
    }
    
    @IBAction func cheat(_ sender: UIButton) {
        game.cheat()
        updateViewFromModel()
    }
    
    @IBAction func touchDealCardsButton(_ sender: UIButton) {
        dealCards()
    }
    
    @objc func dealCards() {
        if !game.deckOfCards.isEmpty {
            game.deal3MoreCards()
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

            var cardView: SetCardView
            if index >= setBoardView.cardViews.count {
                cardView = createCardView()
                configCardView(cardView, for: card)
                setBoardView.cardViews.append(cardView)
                setBoardView.addSubview(cardView)
            } else {
                cardView = setBoardView.cardViews[index]
                configCardView(cardView, for: card)
            }
        }
        
        // Remove off board card view
        for _ in game.playingCards.count..<setBoardView.cardViews.count {            
            setBoardView.cardViews.removeLast().removeFromSuperview()
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
    
    private func createCardView() -> SetCardView {
        let cardView = SetCardView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(choseCard))
        cardView.addGestureRecognizer(tap)
        return cardView
    }
    
    private func configCardView(_ cardView: SetCardView, for card: SetCard) {
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
    
        if game.selectedCards.contains(card) { // highlight selected card view
            cardView.isSelected = true
            if let matched = game.is3SelectedCardsMatched { // Already selected 3 cards
                cardView.isMatched = matched
            }
        } else {
            cardView.isMatched = nil
            cardView.isSelected = false
        }
        
        if let _ = game.currentPlayer { // have a player
            cardView.isUserInteractionEnabled = true
        } else {
            cardView.isUserInteractionEnabled = false
        }
        
    }
}

