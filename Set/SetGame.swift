//
//  SetGame.swift
//  Set
//
//  Created by KangKang on 2017/12/2.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

struct SetGame {
    
    // Invariant:
    let initPlayingCardsCount = 12
    var deckOfCards = [Card]()
    var playingCards = [Card]()
    var selectedCards = [Card]()
    var matchedCards = [Card]()
    var is3SelectedCardsMatched : Bool?
    
    init() {
        setupDeckOfCards()
        setupPlayingCards()
    }
    
    private mutating func matchCards() {
        var countSet = Set<Card.CardCount>()
        var colorSet = Set<Card.CardColor>()
        var shapeSet = Set<Card.CardShape>()
        var grainSet = Set<Card.CardGrain>()
        
        for card in selectedCards {
            countSet.insert(card.count)
            colorSet.insert(card.color)
            shapeSet.insert(card.shape)
            grainSet.insert(card.grain)
        }
        
        if colorSet.count == 2 || countSet.count == 2 || shapeSet.count == 2 || grainSet.count == 2 {
            // Not match
            is3SelectedCardsMatched = false
        } else {
            // Matched
            is3SelectedCardsMatched = true
        }
    }
    
    // Require: select card in the playing cards
    mutating func selectCard(at playingCardindex:Int) {
        if let matched = is3SelectedCardsMatched {
            // Three cards selected
            if matched {
                for card in selectedCards {
                    playingCards.remove(at: playingCards.index(of: card)!)
                    // TODO: deal cards
                    deal3MoreCards()
                }
                deal3MoreCards()
            }
            selectedCards.removeAll()
        }
        
        let selectCard = playingCards[playingCardindex]
        if selectedCards.contains(selectCard) {
            selectedCards.remove(at: selectedCards.index(of: selectCard)!)
//            selectedCards.remove(at: playingCardindex)
        } else {
            selectedCards.append(selectCard)
        }
        
        if selectedCards.count == 3 {
            matchCards()
        } else {
            is3SelectedCardsMatched = nil
        }
    }
    
    mutating func deal3MoreCards() {
        
    }
    
    private mutating func setupDeckOfCards() {
        for count in Card.CardCount.allValues {
            for color in Card.CardColor.allValues {
                for shape in Card.CardShape.allValues {
                    for grain in Card.CardGrain.allValues {
                        deckOfCards.append(Card(count: count, color: color, shape: shape, grain: grain))
                    }
                }
            }
        }
    }
    
    private mutating func setupPlayingCards() {
        for _ in 0..<initPlayingCardsCount {
            playingCards.append(deckOfCards.remove(at: deckOfCards.count.arc4random))
        }
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform((UInt32(self))))
        } else if self < 0 {
            return -Int(arc4random_uniform((UInt32(abs(self)))))
        } else {
            return 0
        }
    }
}
