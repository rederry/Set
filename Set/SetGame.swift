//
//  SetGame.swift
//  Set
//
//  Created by KangKang on 2017/12/2.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

struct SetGame {
    
    // Invariant: deckOfCards.count + playingCards.count + matchedCards.count = 81
    let initPlayingCardsCount = 12
    var deckOfCards = [Card]()
    var playingCards = [Card]()
    var selectedCards = [Card]()
    var matchedCards = [Card]()
    var is3SelectedCardsMatched : Bool? {
        get {
            if selectedCards.count != 3 {
                return nil
            }
            var countSet = Set<Card.CardCount>()
            var colorSet = Set<Card.CardColor>()
            var shapeSet = Set<Card.CardShape>()
            var grainSet = Set<Card.CardGrain>()
            
            selectedCards.forEach {
                countSet.insert($0.count)
                colorSet.insert($0.color)
                shapeSet.insert($0.shape)
                grainSet.insert($0.grain)
            }
            if colorSet.count == 2 || countSet.count == 2 || shapeSet.count == 2 || grainSet.count == 2 {
                return false
            } else {
                return true
            }
        }
    }
    
    init() {
        setupDeckOfCards()
        setupPlayingCards()
    }
    
    // Require: select card in the playing cards
    mutating func selectCard(at playingCardindex:Int) {
        if let matched = is3SelectedCardsMatched {
            if matched { replaceSelectPlayingCardsWithNewCards() }
            selectedCards.removeAll()
        }
        
        let selectCard = playingCards[playingCardindex]
        if selectedCards.contains(selectCard) {
            selectedCards.remove(at: selectedCards.index(of: selectCard)!)
        } else {
            selectedCards.append(selectCard)
        }
    }
    
    mutating func resetGame() {
        deckOfCards.removeAll()
        playingCards.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        setupDeckOfCards()
        setupPlayingCards()
    }
    
    mutating func deal3MoreCards() {
        if let matched = is3SelectedCardsMatched, matched {
            replaceSelectPlayingCardsWithNewCards()
            selectedCards.removeAll();
        } else {
            for _ in 0..<3 { playingCards.append(draw()) }
        }
    }
    
    mutating private func replaceSelectPlayingCardsWithNewCards() {
        playingCards = playingCards.map {
            if selectedCards.contains($0) {
                matchedCards.append($0)
                return deckOfCards.isEmpty ? $0 : draw()
            } else {
                return $0
            }
        }
    }
    
    // Require: !deckOfCards.isEmpty()
    private mutating func draw() -> Card {
        return deckOfCards.remove(at: deckOfCards.count.arc4random)
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
        for _ in 0..<54 {
            deckOfCards.remove(at: 0)
        }
    }
    
    private mutating func setupPlayingCards() {
        for _ in 0..<initPlayingCardsCount {
            playingCards.append(draw())
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
