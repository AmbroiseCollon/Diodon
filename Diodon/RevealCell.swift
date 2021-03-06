//
//  Reveal.swift
//  Diodon
//
//  Created by Ambroise COLLON on 22/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

class RevealCell {
    var game: Game
    var index: GridIndex

    init(in game: Game, atIndex index: GridIndex) {
        self.game = game
        self.index = index
    }

    func execute() {
        self.revealCellAt(index: index)
    }

    private func revealCellAt(index: GridIndex) {
        let cell = game.grid.getCellFor(index: index)

        switch cell.state {
        case .hidden, .flagged:
            switch cell.type {
            case .bomb:
                explode(cell: cell)
            case .plain:
                revealPlain(cell: cell)
                revealNeighboorsIfNeededFor(cell: cell, atIndex: index)
            }
        default:
            break
        }
    }

    private func explode(cell: Cell) {
        cell.state = .exploded
        game.finish()
    }

    private func revealPlain(cell: Cell) {
        cell.state = .revealed
    }

    private func revealNeighboorsIfNeededFor(cell: Cell, atIndex index: GridIndex) {
        if cell.shouldRevealNeighbours {
            revealNeighboursOf(index: index)
        }
    }

    private func revealNeighboursOf(index: GridIndex) {
        let indexes = game.grid.getNeighboursIndexesFor(index: index)
        for neighboorIndex in indexes {
            revealCellAt(index: neighboorIndex)
        }
    }
}
