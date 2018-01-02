//
//  SetGame.swift
//  Set
//
//  Created by KangKang on 2017/12/2.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

/// - Invariant: deckOfCards.count + playingCards.count + matchedCards.count = 81
class SetGame {

    /// The current user score
    private(set) var score = 0
    /// A deck of cards
    private(set) var deckOfCards = [SetCard]()
    /// Current playing cards on table
    private(set) var playingCards = [SetCard]()
    /// Current selected cards
    private(set) var selectedCards = [SetCard]()
    /// Alread mathced cards
    private(set) var matchedCards = [SetCard]()
    /// A set in playing cards
    private var aSetOfCards = [SetCard]()
    /// Have 3 selected cards and matched return true,not matched return false
    /// less than 3 selected cards return nil
    var is3SelectedCardsMatched : Bool? {
        get {
            if selectedCards.count != Constant.aSetCardCount {
                return nil
            }
            return isMatched(with: selectedCards)
        }
    }
    
    /// The score for player1
    private(set) var scoreForPlayer1 = 0
    /// The score for player2
    private(set) var scoreForPlayer2 = 0
    /// The current player to chose a set
    private(set) var currentPlayer : Player?
    enum Player {
        case player1, player2
    }

    /// Set the current player to chose a set
    /// - Parameter player: The player to play
    /// - Requires: player != nil
    func setTurn(for player: Player) {
        currentPlayer = player
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.currentPlayer = nil
            if let matched = self.is3SelectedCardsMatched, matched{
            } else {
                self.selectedCards.removeAll()
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.playerTurnDidFinishNotification), object: nil)
        }
    }
    let playerTurnDidFinishNotification = "playerTurnDidFinish"
        
    /// Creates a set game
    init() {
        setupDeckOfCards()
        setupPlayingCards()
    }
    
    /// Select a card in the game
    /// - Parameter playingCardindex: The index of card in the playing cards
    /// - Precondition: The playingCardindex < playingCards.count
    func selectCard(at playingCardindex:Int) {
        
        // TODO: Refactor(now the order of the code dose mater)
        let selectCard = playingCards[playingCardindex]
        
        if let matched = is3SelectedCardsMatched { // Replace 3 selected cards
            if matched { replaceMatchedPlayingCardsWithNewCardsIfNoCardsInDeckThenRemove() }
            selectedCards.removeAll()
        }
        

        if selectedCards.contains(selectCard) {
            score -= Constant.deselectPenalty
            selectedCards.remove(at: selectedCards.index(of: selectCard)!)
        } else {
            selectedCards.append(selectCard)
        }
        if let matched = is3SelectedCardsMatched { // Update socre
            if matched {
                if let turn = currentPlayer {
                    switch turn {
                    case .player1:
                        scoreForPlayer1 += 1
                    case .player2:
                        scoreForPlayer2 += 1
                    }
                }
                score += Constant.matchPenalty
            } else {
                score -= Constant.mismatchPenalty
            }
        }
    }
    
    /// Shuffle cards on the table
    func shufflePlayingCards() {
        for index in playingCards.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(playingCards.count)))
            playingCards.swapAt(randomIndex, index)
        }
    }
    
    func cheat() {
        if existASetInPlayingCards() {
            selectedCards.removeAll()
            aSetOfCards.forEach { selectedCards.append($0) }
        }
    }
    
    /// Reset the Game to initial state
    func resetGame() {
        deckOfCards.removeAll()
        playingCards.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        setupDeckOfCards()
        setupPlayingCards()
        score = 0
        scoreForPlayer1 = 0
        scoreForPlayer2 = 0
        currentPlayer = nil
    }
    
    /// Deal 3 more cards from deck
    func deal3Cards() {
        if let matched = is3SelectedCardsMatched, matched {
            replaceMatchedPlayingCardsWithNewCardsIfNoCardsInDeckThenRemove()
            selectedCards.removeAll()
        } else {
            if existASetInPlayingCards() {
                score -= Constant.mismatchPenalty
            }
            for _ in 0..<Constant.aSetCardCount { playingCards.append(draw()) }
        }
    }
    
    /// Replace alread matched cards in the playing cards with new cards
    /// If cards out of deck, remove matched cards
    private func replaceMatchedPlayingCardsWithNewCardsIfNoCardsInDeckThenRemove() {
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
    
    // MARK: Extra Credit
    /// Returns true if has a set on the table
    private func existASetInPlayingCards() -> Bool {
        for i in 0..<playingCards.count {
            for j in i+1..<playingCards.count {
                for k in j+1..<playingCards.count {
                    if isMatched(with: [playingCards[i], playingCards[j], playingCards[k]]) {
                        aSetOfCards.removeAll()
                        aSetOfCards += [playingCards[i], playingCards[j], playingCards[k]]
                        return true
                    }
                }
            }
        }
        return false
    }
    
    /// Returns true if the given cards matched
    /// - Parameter cards: to matche
    private func isMatched(with cards:[SetCard]) -> Bool {
        if cards.count != 3 { return false }
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
    
    /// Returns a random card from deck
    /// - Precondition: has card left in deck
    private func draw() -> SetCard {
        return deckOfCards.remove(at: deckOfCards.count.arc4random)
    }
    
    private func setupDeckOfCards() {
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
    
    private func setupPlayingCards() {
        for _ in 0..<Constant.initPlayingCardsCount {
            playingCards.append(draw())
        }
        for _ in 0..<57 {
            deckOfCards.remove(at: 0)
        }
    }
}

extension SetGame {
    struct Constant {
        static let initPlayingCardsCount = 12
        static let deselectPenalty  = 1
        static let matchPenalty = 5
        static let mismatchPenalty = 3
        static let aSetCardCount = 3
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
