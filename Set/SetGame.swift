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
    private let initPlayingCardsCount = 12
    private(set) var score = 0
    private(set) var deckOfCards = [SetCard]()
    private(set) var playingCards = [SetCard]()
    private(set) var selectedCards = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    var is3SelectedCardsMatched : Bool? { // Is 3 selected cards matched or select less than 3 cards
        get {
            if selectedCards.count != 3 {
                return nil
            }
            return isMatched(with: selectedCards)
        }
    }
    
    init() {
        setupDeckOfCards()
        setupPlayingCards()
    }
    
    // Require: select card in the playing cards
    mutating func selectCard(at playingCardindex:Int) {
        if let matched = is3SelectedCardsMatched { // Replace 3 selected cards
            if matched { replaceMatchedPlayingCardsWithNewCardsIfNoCardsInDeckThenRemove() }
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
            replaceMatchedPlayingCardsWithNewCardsIfNoCardsInDeckThenRemove()
            selectedCards.removeAll();
        } else {
            if existASetInPlayingCards() {
                score -= 5
            }
            for _ in 0..<3 { playingCards.append(draw()) }
        }
    }
    
    private mutating func replaceMatchedPlayingCardsWithNewCardsIfNoCardsInDeckThenRemove() {
        if deckOfCards.isEmpty {
            for card in selectedCards {
                playingCards.remove(at: playingCards.index(of: card)!)
                matchedCards.append(card)
            }
        } else {
            playingCards = playingCards.map {
                if selectedCards.contains($0) {
                    matchedCards.append($0)
                    return draw()
                } else {
                    return $0
                }
            }
        }
    }
    
    private func existASetInPlayingCards() -> Bool {
        for i in 0..<playingCards.count {
            for j in i+1..<playingCards.count {
                for k in j+1..<playingCards.count {
                    if isMatched(with: [playingCards[i], playingCards[j], playingCards[k]]) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func isMatched(with cards:[SetCard]) -> Bool {
        var countSet = Set<SetCard.Count>()
        var colorSet = Set<SetCard.Color>()
        var shapeSet = Set<SetCard.Shape>()
        var grainSet = Set<SetCard.Grain>()
        
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
    private mutating func draw() -> SetCard {
        return deckOfCards.remove(at: deckOfCards.count.arc4random)
    }
    
    private mutating func setupDeckOfCards() {
        for count in SetCard.Count.allValues {
            for color in SetCard.Color.allValues {
                for shape in SetCard.Shape.allValues {
                    for grain in SetCard.Grain.allValues {
                        deckOfCards.append(SetCard(count: count, color: color, shape: shape, grain: grain))
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
