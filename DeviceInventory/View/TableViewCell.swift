//
//  TableViewCell.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 05/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

protocol CellProtocol {
    func whenEditButtonPressed(at index: IndexPath)
    func whenDeleteButtonPressed(at index : IndexPath)
}

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var index : IndexPath?
    var cellDelegate : CellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        guard let index = index else { return}
        cellDelegate?.whenDeleteButtonPressed(at : index)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        guard let index = index else { return}
        cellDelegate?.whenEditButtonPressed(at: index)
    }
    
    
}
