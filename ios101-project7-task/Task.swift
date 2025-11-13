//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable{

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    private(set) var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    private(set) var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {
    
    // Key for storing tasks in UserDefaults
    static let tasksKey = "tasks"
    
    static func save(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(tasks) {
            // Save the encoded Data into UserDefaults
            UserDefaults.standard.set(data, forKey: tasksKey)
        }
    }
    
    static func getTasks() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: tasksKey) {
            let decoder = JSONDecoder()
            
            // Try to decode the Data back into an array of Task
            if let tasks = try? decoder.decode([Task].self, from: data) {
                return tasks
            }
        }
        
        return []
    }
    
    func save() {
        var tasks = Task.getTasks()
        
        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks.remove(at: index)
            tasks.insert(self, at: index)
        } else {
            tasks.append(self)
        }
        
        Task.save(tasks)
    }
    
    func delete() {
        var tasks = Task.getTasks()
        
        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks.remove(at: index)
            Task.save(tasks)
        }
    }
}
