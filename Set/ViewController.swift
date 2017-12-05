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

    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var dealButton: UIButton!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender), cardIndex < game.playingCards.count {
            game.selectCard(at: cardIndex)
            updateViewFromModel()
        } else {
            print("Error")
        }
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        game.deal3MoreCards()
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in 0..<game.playingCards.count {
            let button = cardButtons[index]
            let card = game.playingCards[index]
            
            if game.selectedCards.contains(card) { // highlight selected card
                button.layer.borderWidth = 3.0
                if let is3SelectedCardMatched = game.is3SelectedCardsMatched { // Already selected 3 cards
                    if is3SelectedCardMatched {
                        button.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1).cgColor
                        button.isEnabled = false
                    } else {
                        button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
                    }
                } else {
                    button.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1).cgColor
                }
            } else if game.matchedCards.contains(card) {
                button.isEnabled = false
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                button.layer.borderWidth = 0
            } else { // selected less than 3 cards
                button.isEnabled = true
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.layer.borderWidth = 0
            }
            button.setAttributedTitle(figure(for: card), for: UIControlState.normal)
        }
        
        if game.playingCards.count >= cardButtons.count || game.deckOfCards.isEmpty { // No more room or deck out of cards
            dealButton.isEnabled = false
        } else {
            dealButton.isEnabled = true
        }
    }
    
    private func figure(for card: Card) -> NSAttributedString {
        
        var color: UIColor
        switch card.color {
        case .colorA:
            color = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        case .colorB:
            color = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
        case .colorC:
            color = #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1)
        }
        
        var contentStr = ""
        switch card.shape {
        case .shapeA:
            contentStr = "▲"
        case .shapeB:
            contentStr = "●"
        case .shapeC:
            contentStr = "■"
        }
        
        switch card.count {
        case .countA:
            break
        case .countB:
            contentStr += contentStr
        case .countC:
            contentStr += contentStr + contentStr
        }
        
        var width: Int
        switch card.grain {
        case .grainA: // stroke
            width = 5
        default:      // fill or striped
            width = -5
        }
        
        var alpha: CGFloat
        switch card.grain {
        case .grainC: // striped
            alpha = 0.15
        default:
            alpha = 1.00
        }
        
        let attrs: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.strokeColor : color,
            NSAttributedStringKey.strokeWidth : width,
            NSAttributedStringKey.foregroundColor : color.withAlphaComponent(alpha)
        ]
        let attrsText = NSAttributedString(string: contentStr, attributes: attrs)
        return attrsText
    }
    
}

