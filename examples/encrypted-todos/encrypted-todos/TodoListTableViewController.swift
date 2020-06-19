//
//  TodoListTableViewController.swift
//  encrypted-todos
//
//  Copyright © 2020 IronCore Labs. All rights reserved.
//

import UIKit
import os.log
import IronOxide

class TodoListTableViewController: UITableViewController {
    
    //MARK: Properties
    //Hardcoded example device context key
    let ironOxideSdkDevice = """
    {"accountId": "swifttester","segmentId": 1,"signingPrivateKey": "uScugvExVjJDawNHxYOSPrnWBpXoG5MHofHX4Z0+W1uhTWWGGBofQKdYU8sG2YmvI4ptLwc+dEif7I7bDeGFBQ==","devicePrivateKey": "XLy0M319FMUSHlIiq1yEv1mhtZuRo6Ut4xBJ9TqJ8+w="}
    """
    var todoLists = [TodoList]()
    var ironOxideSdk: IronOxide.SDK?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //When the app first loads, initialize the SDK and store it within this Controller
        do {
            let device = IronOxide.DeviceContext(deviceContextJson: ironOxideSdkDevice)!
            ironOxideSdk = try IronOxide.initialize(device: device).get()
            os_log("IronOxide SDK successfully initialized.", log: OSLog.default, type: .debug)
        }
        catch(IronOxide.IronOxideError.error(let message)){
            fatalError("Failed to initialize the IronOxide SDK \(message)")
        }
        catch {
            fatalError("Unexpected error \(error)")
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedTodoLists = loadTodoLists() {
            todoLists += savedTodoLists
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToTodoList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TodoListViewController, let newList = sourceViewController.todoList {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing todo list
                todoLists[selectedIndexPath.row] = newList
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                //Add a new todo list
                let newIndexPath = IndexPath(row: todoLists.count, section: 0)
                todoLists.append(newList)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveTodoLists()
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
            case "AddItem":
                guard let newListNav = segue.destination as? UINavigationController
                else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                let todoListDetailViewController = newListNav.viewControllers.first! as! TodoListViewController
                todoListDetailViewController.ironOxideSdk = ironOxideSdk
                os_log("Adding a new todo list", log: OSLog.default, type: .debug)
            case "ShowDetail":
                guard let todoListDetailViewController = segue.destination as? TodoListViewController
                    else {
                        fatalError("Unexpected destination: \(segue.destination)")
                    }
                guard let selectedTodoListCell = sender as? TodoListTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                guard let indexPath = tableView.indexPath(for: selectedTodoListCell) else {
                    fatalError("The selected cell is not being displayed by the table")
            }
                todoListDetailViewController.todoList = todoLists[indexPath.row]
                todoListDetailViewController.ironOxideSdk = ironOxideSdk
            default:
                fatalError("Unexpected Segue Identifier")
        }
    }


    // MARK: - Table view data source
    //We only have a single section of Todo list items
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoLists.count
    }
    
    // Build up the elements for each rows UI elements. Display elements name and date updated
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TodoListTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TodoListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let list = todoLists[indexPath.row]
        cell.todoListName.text = list.name
        cell.todoListUpdated.text = formatter.string(from: list.updated)
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            todoLists.remove(at: indexPath.row)
            saveTodoLists()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: Private methods
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    //Write out our todos lists to storage
    private func saveTodoLists(){
        let fullPath = getDocumentsDirectory().appendingPathComponent("encryptedTodos")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: todoLists, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Todo lists successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save todo lists...", log: OSLog.default, type: .error)
        }
    }
    
    //Read out the todo lists from storage and sort them by created time
    private func loadTodoLists() -> [TodoList]? {
        let fullPath = getDocumentsDirectory().appendingPathComponent("encryptedTodos")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                let data = Data(referencing:nsData)
                if let loadedTodoLists = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<TodoList> {
                    //Sort the todo lists so that the most recently edited shows up first
                    return loadedTodoLists.sorted(by: { $0.updated > $1.updated })
                }
            } catch {
                os_log("Couldn't read file", log: OSLog.default, type: .error)
                return nil
            }
        }
        return nil
    }
}
