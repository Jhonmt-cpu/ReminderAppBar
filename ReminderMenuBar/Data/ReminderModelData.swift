//
//  Reminders.swift
//  ReminderMenuBar
//
//  Created by João Melo on 24/05/24.
//

import Foundation
import EventKit

private let store = EKEventStore()

public final class ReminderModelData: ObservableObject {
    @Published var allReminders: [EKReminder] = []
    
    init () {
        if self.requestAccess() {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(refreshReminders),
                name: .EKEventStoreChanged,
                object: store
            )
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .EKEventStoreChanged, object: store)
    }
    
    public func requestAccess() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var grantedAccess = false
        store.requestFullAccessToReminders() { granted, _ in
            grantedAccess = granted
            semaphore.signal()
        }
        
        semaphore.wait()
        return grantedAccess
    }
    
    func showLists() {
        let calendars = self.getCalendars()
        for calendar in calendars {
            print(calendar.title)
        }
    }
    
    func showListItems(withName name: String) {
        let calendar = self.calendar(withName: name)

        self.reminders(onCalendar: calendar) { reminders in
            DispatchQueue.main.async {
                self.allReminders = reminders
                
                let today = Calendar.current.startOfDay(for: Date())
                self.allReminders.sort {reminder1, reminder2 in
                    guard let date1 = reminder1.dueDateComponents?.date else {
                        return true;
                    }
                    
                    guard let date2 = reminder2.dueDateComponents?.date else {
                        return false;
                    }
                    
                    let calendar = Calendar.current
                    
                    let hour1 = calendar.component(.hour, from: date1)
                    let hour2 = calendar.component(.hour, from: date2)
                    
                    if (calendar.isDate(date1, inSameDayAs: today) && calendar.isDate(date2, inSameDayAs: today) && hour1 == 0 && hour2 == 0) {
                        guard let creationDate1 = reminder1.creationDate, let creationDate2 = reminder2.creationDate else {
                            return false // If creation dates are missing, keep the current order
                        }
                        
                        return creationDate1 < creationDate2
                    }
                    
                    return date1 < date2
                }
            }
        }
    }
    
    private func reminders(onCalendar calendar: EKCalendar,
            completion: @escaping (_ reminders: [EKReminder]) -> Void)
    {
        let predicate = store.predicateForReminders(in: [calendar])
        store.fetchReminders(matching: predicate) { reminders in
            let today = Calendar.current.startOfDay(for: Date())
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            
            let remindersFiltered = reminders?.filter { reminder in
                guard let dueDate = reminder.dueDateComponents?.date else {
                    return false
                }
                
                return !reminder.isCompleted && (dueDate >= today && dueDate < tomorrow)
            }
            
            
            completion(remindersFiltered ?? [])
            
        }
    }
    
    func complete(reminder: EKReminder) {
        do {
            reminder.isCompleted = true
            try store.save(reminder, commit: true)
            print("Completed '\(reminder.title!)'")
        } catch let error {
            print("Failed to save reminder with error: \(error)")
            exit(1)
        }
    }
    
    private func calendar(withName name: String) -> EKCalendar {
        if let calendar = self.getCalendars().first(where: { $0.title.lowercased() == name.lowercased() }) {
            return calendar
        } else {
            print("No reminders list matching \(name)")
            exit(1)
        }
    }
    
    @objc private func refreshReminders() -> Void {
        showListItems(withName: "Reminders")
    }
    
    private func getCalendars() -> [EKCalendar] {
        return store.calendars(for: .reminder)
    }
}
