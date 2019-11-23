//
//  HistoryVC.swift
//  FlipCardsChallenge
//
//  Created by Денис Андриевский on 11/21/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit
import CoreData

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var dataBase = [Game]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        DispatchQueue.global(qos: .utility).async {
            // MARK:- Get data from Core Data
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
            
            request.returnsObjectsAsFaults = false
            do {
                let result = try self.context.fetch(request)
                DispatchQueue.main.async {
                    self.dataBase = result as! [Game]
                    self.tableView.reloadData()
                }
                
                
            } catch {
                print("Failed")
            }
            
            // Getting data finished
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataBase.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HistoryCell.self), for: indexPath) as! HistoryCell
        cell.title.text = dataBase[indexPath.section].title
        cell.dateLabel.text = dataBase[indexPath.section].date
        cell.img.image = UIImage(data: dataBase[indexPath.section].image!)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, _, completion) in
            self.context.delete(self.dataBase[indexPath.section])
            self.dataBase.remove(at: indexPath.section)
            self.tableView.reloadData()
            self.appDelegate.saveContext()
        }
        deleteAction.image = UIImage(named: "delete")
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionsConfiguration
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "backToMainMenu", sender: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

}
