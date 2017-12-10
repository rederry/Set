//
//  SetGame.swift
//  Set
//
//  Created by KangKang on 2017/12/2.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

struct SetGame {
    
    private let initPlayingCardsCount = 12
    private(set) var score = 0
    private(set) var deckOfCards = [Card]()
    private(set) var playingCards = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var matchedCards = [Card]()
    var is3SelectedCardsMatched : Bool? { // Is 3 selected cards matched or select less than 3 cards
        get {
            if selectedCards.count != 3 {
                return nil
            }
            return matched(with: selectedCards)
        }
    }
    
    init() {
        setupDeckOfCards()
        setupPlayingCards()
    }
    
    // Require: select card in the playing cards
    mutating func selectCard(at playingCardindex:Int) {
        if let matched = is3SelectedCardsMatched { // Replace 3 selected cards
            if matched { replaceMatchedPlayingCardsWithNewCards() }
            selectedCards.removeAll()
        }
        
        let selectCard = playingCards[playingCardindex]
        if selectedCards.contains(selectCard) {
            score -= 1
            selectedCards.remove(at: selectedCards.index(of: selectCard)!)
        } else {
            selectedCards.append(selectCard)
        }
        if let matched = is3SelectedCardsMatched { // Update socre
            score = matched ? score+3 : score-5
        }
    }
    
    mutating func resetGame() {
        deckOfCards.removeAll()
        playingCards.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        setupDeckOfCards()
        setupPlayingCards()
        score = 0
    }
    
    // MARK: Extra Credit
    mutating func deal3MoreCards() {
        if let matched = is3SelectedCardsMatched, matched {
            replaceMatchedPlayingCardsWithNewCards()
            selectedCards.removeAll();
        } else {
            if existASetInPlayingCards() {
                score -= 5
            }
            for _ in 0..<3 { playingCards.append(draw()) }
        }
    }
    
    private mutating func replaceMatchedPlayingCardsWithNewCards() {
        playingCards = playingCards.map {
            if selectedCards.contains($0) {
                matchedCards.append($0)
                return deckOfCards.isEmpty ? $0 : draw()
            } else {
                return $0
            }
        }
    }
    
    private func existASetInPlayingCards() -> Bool {
        for i in 0..<playingCards.count {
            for j in i+1..<playingCards.count {
                for k in j+1..<playingCards.count {
                    if matched(with: [playingCards[i], playingCards[j], playingCards[k]]) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func matched(with cards:[Card]) -> Bool {
        var countSet = Set<Card.CardCount>()
        var colorSet = Set<Card.CardColor>()
        var shapeSet = Set<Card.CardShape>()
        var grainSet = Set<Card.CardGrain>()
        
        cards.forEach {
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
