//
//  Game.swift
//  memo
//
//  Created by Artsiom Sadyryn on 1/8/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import Foundation

class Game {
    
    private let cardNames = (1...19).map { "card\($0)" }
    var isFinished = false
    var cardPairs: Int
    var flippedCard: Int?
    var cards: [Card]
    
    init(cardPairs: Int) {
        
        if cardPairs > 18 {
            self.cardPairs = 18
        }
        else {
            self.cardPairs = cardPairs
        }
        
        var names = [String]()
        cards = [Card]()
        var indexArr: [Int] = [0]
        var index: UInt32 = 0
        for _ in 0..<cardPairs {
            repeat {
                index = arc4random_uniform(UInt32(cardNames.count))
                indexArr.append(Int(index))
            } while indexArr.filter { $0 != Int(index) }.isEmpty
            names.append(cardNames[Int(index)])
        }

        for name in names {
            let card = Card(isFlipped: false, imageName: name, isMatched: false)
            let card2 = Card(isFlipped: false, imageName: name, isMatched: false)
            cards.append(card)
            cards.append(card2)
        }

        cards = cards.shuffle()
    }
    
    func cardFlipped(at index: Int) {
        cards[index].isFlipped = true
        if let flipped = flippedCard {
            twoCardsFlipped(cardOne: flipped, cardTwo: index)
            flippedCard = nil
        }
        else {
            flippedCard = index
        }
        
        let center = NotificationCenter.default
    }
    
    func twoCardsFlipped(cardOne: Int, cardTwo: Int) -> Bool {
        if cards[cardOne] == cards[cardTwo] {
            cards[cardOne].isMatched = true
            cards[cardTwo].isMatched = true
            let cardsRemained = cards.filter { !($0.isFlipped) }.count
            if cardsRemained == 0 {
                isFinished = true
                print("Game finished")
            }
            return true
        }
        else {
            cards[cardOne].isFlipped = true
            cards[cardTwo].isFlipped = true
            return false
        }
    }

}
