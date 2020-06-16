//
//  TodoListTableViewCell.swift
//  encrypted-todos
//
//  Copyright © 2020 IronCore Labs. All rights reserved.
//

import UIKit

class TodoListTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var todoListName: UILabel!
    @IBOutlet weak var todoListUpdated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
