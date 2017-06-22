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

    func testWhenCreatingGrid_WidthAndHeightAreOk() {
        XCTAssertNotNil(grid)
        XCTAssertEqual(grid.width, 3)
        XCTAssertEqual(grid.height, 4)
    }

    func testWhenCreatingEmptyGrid_WidthAndHeightAreNull() {
        let emptyGrid = Grid(matrix: [[Cell]]())
        XCTAssertEqual(emptyGrid.width, 0)
        XCTAssertEqual(emptyGrid.height, 0)
    }

    func testWhenRemovingFirstRowAndAppendingNewRow_ThenHeightRemainsConstant() {
        let aGrid = Grid(width: 7, height: 10)
        aGrid.removeFirstAndAppendRow()
        XCTAssertEqual(aGrid.height, 10)
    }

    func testWhenCalculatingBombCounts_TheyAreAllOK() {
        grid.calculateAllNeighboringBombCounts()

        var result = [Int]()
        for row in 0..<grid.height {
            for column in 0..<grid.width {
                let bombCount = grid.getCellFor(index: GridIndex(row, column)).neighboringBombCount
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
}
