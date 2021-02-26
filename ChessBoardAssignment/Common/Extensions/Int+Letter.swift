//
//  Int+Letter.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import Foundation

extension Int {
    var boardLetter: String? {
        var posChar: String?
        let startingValue = Int(("A" as UnicodeScalar).value)
        if let char = UnicodeScalar(startingValue + self) {
            posChar = String(Character(char))
        }
        return posChar
    }
}
