//
//  EvaluateCell.swift
//  Diodon
//
//  Created by Ambroise COLLON on 22/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

class EvaluateCell {
    var game: Game
    var cell: Cell

    init(cell: Cell, forGame game: Game) {
        self.cell = cell
        self.game = game
    }

    func execute() {
        switch cell.state {
        case .hidden, .exploded:
            game.finish()
        case .flagged:
        	evaluateFlag()
        case.revealed:
            break
        }
    }

    private func evaluateFlag() {
        switch cell.type {
        case .bomb:
            game.incrementScore()
        case.plain:
            game.finish()
        }
    }
}
