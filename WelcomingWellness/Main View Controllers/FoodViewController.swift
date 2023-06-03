//
//  FoodViewController.swift
//  WelcomingWellness
//
//  Created by Jason Wong on 6/2/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import UIKit
class FoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let food: [String] = ["Beef", "Chicken", "Tofu", "Sheep", "Goat", "Brussel Sprouts", "Kale"]
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    
    
    @IBOutlet weak var DietRestrictions: UIButton!
    
    
    // number of rows in table view

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.food.count
    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        // set the text from the data model
        cell.textLabel?.text = self.food[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isEditing = true
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
         self.tableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        let optionsClosure = { (action: UIAction) in
          print(action.title)
        }
        DietRestrictions.menu = UIMenu(children: [
          UIAction(title: "No Preference", state: .on, handler: optionsClosure),
          UIAction(title: "Vegeterian", handler: optionsClosure),
          UIAction(title: "Vegan", handler: optionsClosure)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

}
