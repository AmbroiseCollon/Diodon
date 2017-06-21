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

        let result = grid.matrix.map { (row) -> [Int] in
            return row.map({ (cell) -> Int in
                return cell.neighboringBombCount
            })
        }
        let flattenedResult = Array(result.joined())

        let expected = [
            2,2,0,
            2,2,0,
            1,2,1,
            0,1,1,
        ]

        XCTAssertEqual(expected, flattenedResult)
    }


    func testRevealCellWhenItContainsBomb() {
        grid.revealCellAt(row: 0, column: 0)
        XCTAssertEqual(grid.matrix[0][0].state, .exploded)
    }

    func testRevealCellWhenItsPlain() {
        grid.calculateAllNeighboringBombCounts()
        grid.revealCellAt(row: 0, column: 1)
        XCTAssertEqual(grid.matrix[0][1].state, .revealed)
        XCTAssertNotEqual(grid.matrix[0][0].state, .revealed)
        XCTAssertNotEqual(grid.matrix[0][2].state, .revealed)
        XCTAssertNotEqual(grid.matrix[1][0].state, .revealed)
        XCTAssertNotEqual(grid.matrix[1][1].state, .revealed)
        XCTAssertNotEqual(grid.matrix[1][2].state, .revealed)
    }

    func testRevealCellWhenItsPlainAndWithoutNeighboringBombs() {
        grid.calculateAllNeighboringBombCounts()
        grid.revealCellAt(row: 0, column: 2)
        XCTAssertEqual(grid.matrix[0][2].state, .revealed)
        XCTAssertEqual(grid.matrix[0][1].state, .revealed)
        XCTAssertEqual(grid.matrix[1][1].state, .revealed)
        XCTAssertEqual(grid.matrix[1][2].state, .revealed)
        XCTAssertEqual(grid.matrix[2][1].state, .revealed)
        XCTAssertEqual(grid.matrix[2][2].state, .revealed)
    }
}
