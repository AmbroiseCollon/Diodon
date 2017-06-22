//
//  Reveal.swift
//  Diodon
//
//  Created by Ambroise COLLON on 22/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

class RevealCell {
    var grid: Grid
    var index: GridIndex

    init(in grid: Grid, atIndex index: GridIndex) {
        self.grid = grid
        self.index = index
        self.revealCellAt(index: index)
    }

    private func revealCellAt(index: GridIndex) {
        let cell = grid.getCellFor(index: index)

        switch cell.state {
        case .hidden, .flagged:
            switch cell.type {
            case .bomb:
                explode(cell: cell, atIndex: index)
            case .plain:
                revealPlain(cell: cell, atIndex: index)
                revealNeighboorsIfNeededFor(cell: cell, atIndex: index)
            }
        default:
            break
        }
    }

    private func explode(cell: Cell, atIndex index: GridIndex) {
        var cell = cell
        cell.state = .exploded
        grid.set(cell: cell, atIndex: index)
    }

    private func revealPlain(cell: Cell, atIndex index: GridIndex) {
        var cell = cell
        cell.state = .revealed
        grid.set(cell: cell, atIndex: index)
    }

    private func revealNeighboorsIfNeededFor(cell: Cell, atIndex index: GridIndex) {
        if cell.shouldRevealNeighbours {
            revealNeighboursOf(index: index)
        }
    }

    private func revealNeighboursOf(index: GridIndex) {
        let indexes = grid.getNeighboursIndexesFor(index: index)
        for neighboorIndex in indexes {
            revealCellAt(index: neighboorIndex)
        }
    }
}
