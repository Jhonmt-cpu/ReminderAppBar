//
//  PadEnd.swift
//  ReminderMenuBar
//
//  Created by João Melo on 11/06/24.
//

extension String {
    func padEnd(toLength length: Int, withPad pad: String = " ") -> String {
        let newLength = self.count
        if newLength < length {
            let padding = String(repeating: pad, count: length - newLength)
            return self + padding
        } else {
            return self
        }
    }
}
