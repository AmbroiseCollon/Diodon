//
//  Grid.swift
//  Diodon
//
//  Created by Ambroise COLLON on 20/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

struct Grid {
    var matrix = [[Cell]]()

    var width: Int {
        if let row = matrix.first {
            return row.count
        }
        return 0
    }

    var height: Int {
        return matrix.count
    }

    init(matrix: [[Cell]]) {
        self.matrix = matrix
    }

    init(width: Int, height: Int) {
        let row = Array(repeating: Cell(), count: width)
        self.matrix = Array(repeating: row, count: height)
    }
}

// MARK: - Remove first and append row
extension Grid {
    mutating func removeFirstAndAppendRow() {
        removeFirstRow()
        appendRow()
    }

    private mutating func removeFirstRow() {
        matrix.removeFirst()
    }

    private mutating func appendRow() {
        let newRow = Array(repeating: Cell(), count: width)
        matrix.append(newRow)
    }
}

// MARK: - Calculate all neighboting bomb counts
extension Grid {
    mutating func calculateAllNeighboringBombCounts() {
        for rowIndex in 0..<matrix.count {
            let row = matrix[rowIndex]
            for columnIndex in 0..<row.count {
                calculateAllNeighboringBombCountsForCellAt(row: rowIndex, column: columnIndex)
            }
        }
    }

    private mutating func calculateAllNeighboringBombCountsForCellAt(row: Int, column: Int) {
        let neighboringCells = getNeighboringCellsFor(row: row, column: column)
        let neighboringBombedCells = neighboringCells.filter { (cell) -> Bool in
            return cell.type == .bomb
        }
        matrix[row][column].neighboringBombCount = neighboringBombedCells.count
    }


    private func getNeighboringCellsFor(row: Int, column: Int) -> [Cell] {
        let rowMin = Int.maximum(0, row - 1)
        let rowMax = Int.minimum(height - 1, row + 1)
        let columnMin = Int.maximum(0, column - 1)
        let columnMax = Int.minimum(width - 1, column + 1)

        var cells = [Cell]()
        for rowIndex in rowMin...rowMax {
            for columnIndex in columnMin...columnMax {
                cells.append(matrix[rowIndex][columnIndex])
            }
        }

        return cells
    }

}

// MARK: - Did reveal cell
extension Grid {
    mutating func revealCellAt(row: Int, column: Int) {
        let cell = matrix[row][column]

        switch cell.state {
        case .hidden, .flagged:
            switch cell.type {
            case .bomb:
                matrix[row][column].state = .exploded
            case .plain:
                matrix[row][column].state = .revealed
                if cell.shouldRevealNeighbours {
                    revealNeighboursFor(row: row, column: column)
                }
            }
        default:
            break
        }
    }

    private mutating func revealNeighboursFor(row: Int, column: Int) {
        let indexes = getNeighboringIndexesFor(row: row, column: column)
        print(indexes)
        for (row, column) in indexes {
            revealCellAt(row: row, column: column)
        }
    }

    private func getNeighboringIndexesFor(row: Int, column: Int) -> [(Int, Int)] {
        let rowMin = Int.maximum(0, row - 1)
        let rowMax = Int.minimum(height - 1, row + 1)
        let columnMin = Int.maximum(0, column - 1)
        let columnMax = Int.minimum(width - 1, column + 1)

        var indexes = [(Int, Int)]()
        for rowIndex in rowMin...rowMax {
            for columnIndex in columnMin...columnMax {
                if !(rowIndex == row && columnIndex == column) {
                    indexes.append((row: rowIndex, column: columnIndex))
                }
            }
        }

        return indexes
    }
}
