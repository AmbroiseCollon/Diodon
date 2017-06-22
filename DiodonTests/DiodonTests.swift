//
//  DiodonTests.swift
//  DiodonTests
//
//  Created by Ambroise COLLON on 20/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import XCTest
@testable import Diodon

class DiodonTests: XCTestCase {

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
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateCell() {
        let cell = Cell()
        XCTAssertNotNil(cell)
        XCTAssert(cell.type == .plain || cell.type == .bomb)
        XCTAssertEqual(cell.state, .hidden)
        XCTAssertEqual(cell.neighboringBombCount, 0)
    }

    func testCreateGrid() {
        XCTAssertNotNil(grid)
        XCTAssertEqual(grid.width, 3)
        XCTAssertEqual(grid.height, 4)
    }

    func testRemoveFirstAndAppendLastRow() {
        var customGrid = Grid(width: 7, height: 10)
        customGrid.removeFirstAndAppendRow()
        XCTAssertEqual(customGrid.height, 10)
    }

    func testCalculateNeighboringBombsCount() {
        grid.calculateAllNeighboringBombCounts()

        var result = [Int]()
        for row in 0..<grid.height {
            for column in 0..<grid.width {
                let bombCount = grid.getCellFor(row: row, column: column).neighboringBombCount
                result.append(bombCount)
            }
        }

        let expected = [
            1,2,0,
            1,2,0,
            1,2,1,
            0,1,0
        ]

        XCTAssertEqual(expected, result)
    }


    func testRevealCellWhenItContainsBomb() {
        grid.revealCellAt(row: 0, column: 0)
        XCTAssertEqual(grid.getCellFor(row: 0, column: 0).state, .exploded)
    }

    func testRevealCellWhenItsPlain() {
        grid.calculateAllNeighboringBombCounts()
        grid.revealCellAt(row: 0, column: 1)
        XCTAssertEqual(grid.getCellFor(row: 0, column: 1).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(row: 0, column: 0).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(row: 0, column: 2).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(row: 1, column: 0).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(row: 1, column: 1).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(row: 1, column: 2).state, .revealed)
    }

    func testRevealCellWhenItsPlainAndWithoutNeighboringBombs() {
        grid.calculateAllNeighboringBombCounts()
        grid.revealCellAt(row: 0, column: 2)
        XCTAssertEqual(grid.getCellFor(row: 0, column: 2).state, .revealed)
        XCTAssertEqual(grid.getCellFor(row: 0, column: 1).state, .revealed)
        XCTAssertEqual(grid.getCellFor(row: 1, column: 1).state, .revealed)
        XCTAssertEqual(grid.getCellFor(row: 1, column: 2).state, .revealed)
        XCTAssertEqual(grid.getCellFor(row: 2, column: 1).state, .revealed)
        XCTAssertEqual(grid.getCellFor(row: 2, column: 2).state, .revealed)
    }
}
