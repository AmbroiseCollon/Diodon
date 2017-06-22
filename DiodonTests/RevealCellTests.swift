//
//  RevealCellTest.swift
//  Diodon
//
//  Created by Ambroise COLLON on 22/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import XCTest
@testable import Diodon

class RevealCellTests: XCTestCase {
    
    var game = Game()

    override func setUp() {
        super.setUp()
        let grid = Grid(matrix: [
            [Cell(type: .bomb), Cell(type: .plain), Cell(type: .plain)],
            [Cell(type: .bomb), Cell(type: .plain), Cell(type: .plain)],
            [Cell(type: .plain), Cell(type: .plain), Cell(type: .plain)],
            [Cell(type: .plain), Cell(type: .plain), Cell(type: .bomb)],
            ])
        game = Game(grid: grid)
    }
    
    func testGivenCellContainsABomb_WhenRevealingIt_ThenItExplodesAndGameIsOver() {
        let revealCell = RevealCell(in: game, atIndex: GridIndex(0, 0))
        revealCell.execute()
        XCTAssertEqual(game.grid.getCellFor(index: GridIndex(0, 0)).state, .exploded)
        XCTAssertEqual(game.state, .over)
    }

    func testGivenCellIsEmptyAndNextToABomb_WhenRevealingIt_ThenItRevealsIt() {
        let revealCell = RevealCell(in: game, atIndex: GridIndex(0, 1))
        revealCell.execute()

        let grid = game.grid
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 1)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(0, 0)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(0, 2)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(1, 0)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(1, 1)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(1, 2)).state, .revealed)
    }

    func testGivenCellIsEmptyAndHasNoBombNextToIt_WhenRevealingIt_ThenItRevealsTheCellAndTheOnesArroundIt() {
        let revealCell = RevealCell(in: game, atIndex: GridIndex(0, 2))
        revealCell.execute()

        let grid = game.grid
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 2)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 1)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(1, 1)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(1, 2)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(2, 1)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(2, 2)).state, .revealed)
    }
}
