//
//  CategoryTableViewController.swift
//  Stone
//
//  Created by Jack Flintermann on 12/6/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    let crystalStore: CrystalStore
    init(crystalStore: CrystalStore) {
        self.crystalStore = crystalStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vibes"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
    }
    
    func categoryAt(indexPath: NSIndexPath) -> Category {
        let categories = Array(self.crystalStore.allCategories).sort()
        return categories[indexPath.row]
    }
    
    func dismiss() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.crystalStore.allCategories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = self.categoryAt(indexPath)
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        crystalStore.selectedCategory.value = self.categoryAt(indexPath)
        dismiss()
    }

}
