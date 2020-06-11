//
//  TodoListViewController.swift
//  encrypted-todos
//
//  Copyright © 2020 IronCore Labs. All rights reserved.
//

import UIKit
import os.log
import IronOxide

class TodoListViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var todoListTitleTextField: UITextField!
    @IBOutlet weak var todoListItemsTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var todoList: TodoList?
    var ironOxideSdk: IronOxide.SDK?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoListTitleTextField.delegate = self
        
        //Bail if we somehow got to this controller without an IronOxide SDK instance
        if ironOxideSdk == nil {
            fatalError("No SDK instance provided to TodoListViewController")
        }
        
        //If we have an existing list, decrypt the content and set the decrypted value in the todo list content
        if let todoList = todoList{
            navigationItem.title = todoList.name
            todoListTitleTextField.text = todoList.name
            do {
                let todoListDecryptResult = try ironOxideSdk!.document.decrypt(encryptedBytes: todoList.encryptedContent).get()
                todoListItemsTextView.text = String(bytes: todoListDecryptResult.decryptedData, encoding: .utf8)
            }
            catch(IronOxide.IronOxideError.error(let message)){
                fatalError("The todo list could not be decrypted \(message)")
            }
            catch {
                fatalError("Unexpected error \(error)")
            }
        }
        
        updateSaveButtonState()
        //Add a border around the textview, otherwise it looks invisible
        todoListItemsTextView.layer.borderWidth = 1.0
        todoListItemsTextView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        todoListItemsTextView.layer.cornerRadius = 5.0
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the Save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = todoListTitleTextField.text
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let listName = todoListTitleTextField.text ?? "{no name}"
        let listItems = todoListItemsTextView.text ?? ""
        
        //Check if we're updating an existing list or encrypting a new list and call the proper method
        if todoList == nil {
            todoList = encryptNewList(name: listName, items: listItems)
        }
        else {
            todoList = encryptExistingList(documentId: IronOxide.DocumentId(todoList!.id)!, name: listName, items: listItems)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //Depending on the style of presentation, this view controller needs to be dismissed in two different ways
        if presentingViewController is UINavigationController {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TodoListViewController is not inside a navigation controller.")
        }
    }
    
    
    //MARK: Private Methods
    
    private func updateSaveButtonState(){
        //Disable the Save button if the text field is empty
        saveButton.isEnabled = !(todoListTitleTextField.text ?? "").isEmpty
    }
    
    //Update the data for an existing encrypted list
    private func encryptExistingList(documentId: IronOxide.DocumentId, name: String, items: String) -> TodoList{
        do {
            let encryptedList = try ironOxideSdk!.document.updateBytes(documentId: documentId, newBytes: Array(items.utf8)).get()
            return TodoList(name: name, encryptResult: encryptedList)
        }
        catch(IronOxide.IronOxideError.error(let message)){
            fatalError("The todo list could not be encrypted \(message)")
        }
        catch {
            fatalError("Unexpected error \(error)")
        }
    }
    
    //Encrypt a new list
    private func encryptNewList(name: String, items: String) -> TodoList{
        do {
            let encryptedList = try ironOxideSdk!.document.encrypt(bytes: Array(items.utf8)).get()
            return TodoList(name: name, encryptResult: encryptedList)
        }
        catch(IronOxide.IronOxideError.error(let message)){
            fatalError("The todo list could not be encrypted \(message)")
        }
        catch {
            fatalError("Unexpected error \(error)")
        }
    }
}
