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
    
    var grid = Grid(width: 0, height: 0)

    override func setUp() {
        super.setUp()
        grid = Grid(matrix: [
            [Cell(type: .bomb), Cell(type: .plain), Cell(type: .plain)],
            [Cell(type: .bomb), Cell(type: .plain), Cell(type: .plain)],
            [Cell(type: .plain), Cell(type: .plain), Cell(type: .plain)],
            [Cell(type: .plain), Cell(type: .plain), Cell(type: .bomb)],
            ])
    }
    
    func testGivenCellContainsABomb_WhenRevealingIt_ThenItExplodes() {
        let revealCell = RevealCell(in: grid, atIndex: GridIndex(0, 1))
        revealCell.execute()
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 0)).state, .exploded)
    }

    func testGivenCellIsEmptyAndNextToABomb_WhenRevealingIt_ThenItRevealsIt() {
        grid.calculateAllNeighboringBombCounts()
        let revealCell = RevealCell(in: grid, atIndex: GridIndex(0, 1))
        revealCell.execute()
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 1)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(0, 0)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(0, 2)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(1, 0)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(1, 1)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(1, 2)).state, .revealed)
    }

    func testGivenCellIsEmptyAndHasNoBombNextToIt_WhenRevealingIt_ThenItRevealsTheCellAndTheOnesArroundIt() {
        grid.calculateAllNeighboringBombCounts()
        let revealCell = RevealCell(in: grid, atIndex: GridIndex(0, 2))
        revealCell.execute()
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 2)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 1)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(1, 1)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(1, 2)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(2, 1)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(2, 2)).state, .revealed)
    }
}
