//
//  Field.swift
//  FlipCardsChallenge
//
//  Created by Денис Андриевский on 11/19/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import Foundation

typealias Field = [[Card]]

extension Field {
    
    mutating func rotate(at coors: (Int, Int)) {

        self = self.map { $0.map{ $0.status == .done ? $0 : Card(status: .normal, image: $0.image)} }
        self = self.enumerated().map {
            let index1 = $0.0; var element = $0.1
            element = element.enumerated().map {
                let index2 = $0.0; let el = $0.1
                if ((index1, index2) == coors && el.status == .done) {
                    return $0.element
                }
                return ((index1, index2) == coors) ? Card(status: .rotated, image: $0.element.image) : el
            }
            return element
        }
        
    }
    
    mutating func rotateWithoutCheck(at coors: (Int, Int)) {

        self = self.enumerated().map {
            let index1 = $0.0; var element = $0.1
            element = element.enumerated().map {
                let index2 = $0.0; let el = $0.1
                if ((index1, index2) == coors && el.status == .done) {
                    return $0.element
                }
                return ((index1, index2) == coors) ? Card(status: .rotated, image: $0.element.image) : el
            }
            return element
        }
        
    }
    
    mutating func generateRandomGameField() {
        
        var possibleImages: [Image] = [.apple, .banana, .berry, .cherry, .peach, .pear]
        var newField = [Card]()
        for img in possibleImages {
            newField.append(Card(status: .normal, image: img))
            newField.append(Card(status: .normal, image: img))
            possibleImages.remove(at: possibleImages.firstIndex(of: img)!)
        }
        newField.shuffle()
        
        var field = Field()
        var counter = 0
        var subArray = [Card]()
        for element in newField {
            subArray.append(element)
            counter += 1
            if counter == 4 {
                counter = 0
                field.append(subArray)
                subArray = []
            }
        }
        
        self = field
        
        
        
    }
    
}
