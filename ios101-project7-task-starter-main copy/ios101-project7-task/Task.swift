//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable, Equatable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date
    
    
    
    func addToTasks() {
        // 1.
        var currentTasks = Task.getTasks(forKey: Task.tasksKey)
        // 2.
        currentTasks.append(self)
        // 3.
        Task.save(currentTasks, forKey: Task.tasksKey)
    }
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
    let createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    let id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {

    static var tasksKey: String {
        return "Foxy"
    }
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task], forKey key: String) {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        let encodedData = try! JSONEncoder().encode(tasks)
        // 3.
        defaults.set(encodedData, forKey: key)
    }
    static func getAllTasks() -> [Task]? {
        print("well at least we entered the useless function that always returns null")
        let defaults = UserDefaults.standard

        if let data = defaults.data(forKey: Task.tasksKey) {
            do {
                print("sucess")
                let decodedTasks = try JSONDecoder().decode([Task].self, from: data)
                return decodedTasks
            } catch {
                print("Failed to decode tasks: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func getTasks(forKey key: String? = "Foxy") -> [Task] {
        let defaults = UserDefaults.standard
        
        if key == "all" {
            print("oh boy")
            if let allTasks = Task.getAllTasks() {
                // Use the retrieved tasks
                print("Retrieved \(allTasks.count) tasks.")
                print(allTasks)
                return allTasks
            } else {
                print("No saved tasks found.")
                return []
            }
        } else if let key = key, let data = defaults.data(forKey: key) {
            let decodedTasks = try! JSONDecoder().decode([Task].self, from: data)
            return decodedTasks
        }
        
        return []
    }
       

    func addToCurrentTasks() {
        print("we have entered the function")
        // 1.
        var currentTasks = Task.getTasks(forKey: Task.tasksKey)
        // 2.
        currentTasks.append(self)
        // 3.
        Task.save(currentTasks, forKey: Task.tasksKey)
    }

    
    func removeFromCurrentTasks() {
        print(self.title)
        // 1.
        print("inside remove ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\n\n\n\n")
        print("LISTEN UP")
        print(self.title)
        var currentTasks = Task.getTasks(forKey: Task.tasksKey)
        // 2.
        print("before*******************************\n\n\n\n\n")
        for t in currentTasks{
            print(t.title)
        }
        currentTasks.removeAll { task in
            // 3.
            return self.title == task.title
            
        }
        print("after$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n\n\n")
        for t in currentTasks{
            print(t.title)
        }
        // 4.
        Task.save(currentTasks, forKey: Task.tasksKey)
    }
    
    // Add a new task or update an existing task with the current task.
    func save() {

            let defaults = UserDefaults.standard
            // 2.
            let encodedData = try! JSONEncoder().encode(self)
            // 3.
        defaults.set(encodedData, forKey: self.id)
        
        
        // TODO: Save the current task
    }
}
