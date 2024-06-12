//
//  ReminderFormatter.swift
//  ReminderMenuBar
//
//  Created by João Melo on 27/05/24.
//

import EventKit

private let dateFormatter = RelativeDateTimeFormatter()

func formattedDueDate(from reminder: EKReminder) -> String? {
    return reminder.dueDateComponents?.date.map {
        dateFormatter.localizedString(for: $0, relativeTo: Date())
    }
}

func format(_ reminder: EKReminder, at index: Int) -> String {
    let dateString = formattedDueDate(from: reminder).map { " (\($0))" } ?? ""
    return "\(index): \(reminder.title ?? "<unknown>")\(dateString)"
}
