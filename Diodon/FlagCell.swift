//
//  FlagCell.swift
//  Diodon
//
//  Created by Ambroise COLLON on 22/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

class FlagCell {
    var grid: Grid
    var index: GridIndex

    init(in grid: Grid, atIndex index: GridIndex) {
        self.grid = grid
        self.index = index
        self.flagCell()
    }

    func flagCell() {
        var cell = grid.getCellFor(index: index)

        switch cell.state {
        case .hidden:
            cell.state = .flagged
        case .flagged:
            cell.state = .hidden
        case .revealed, .exploded:
            break
        }

        grid.set(cell: cell, atIndex: index)
    }
}
