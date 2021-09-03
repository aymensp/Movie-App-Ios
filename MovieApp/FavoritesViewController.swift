//
//  FavoritesViewController.swift
//  WorkshopIOSTV
//
//  Created by Khaled Guedria on 10/25/20.
//  Copyright © 2020 Khaled Guedria. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    //var
    var favorites = [String]()
    var i : Int!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let favCell = tableView.dequeueReusableCell(withIdentifier: "favCell")
        let contentView = favCell?.contentView
        
        let label = contentView?.viewWithTag(1) as! UILabel
        let imageView = contentView?.viewWithTag(2) as! UIImageView
        
        label.text = favorites[indexPath.row]
        imageView.image = UIImage(named: favorites[indexPath.row])
        

        return favCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        i = indexPath.row
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let param = sender as! String
        if segue.identifier == "mSegue2" {
            
            let destination = segue.destination as! DetailsViewController
            destination.movieName = param
        }
    }
    
  
    @IBAction func deleteeee(_ sender: Any) {
        
        deleteElement(tableView: self.tableView, index: i)
        print("CELL DELETING ...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    
    func fetchData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        do {
            
            let data = try managedContext.fetch(request)
            for item in data {
                
                favorites.append(item.value(forKey: "movieName") as! String)
                
            }
            
        } catch  {
            
            print("Fetching error !")
        }
        
    }
    

    func getByCreateria(movieName: String) -> NSManagedObject{
        
        var movieExist:NSManagedObject?
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        let predicate = NSPredicate(format: "movieName = %@", movieName)
        request.predicate = predicate
        
        do {
            let result = try managedContext.fetch(request)
            if result.count > 0 {
                
                movieExist = (result[0] as! NSManagedObject)
                print("Movie exists !")
                
            }
            
        } catch {
            
            print("Fetching by criteria error !")
        }
        
        
        return movieExist!
    }
    
    
    func deleteElement(tableView: UITableView, index: Int) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let object = getByCreateria(movieName: favorites[index])
        managedContext.delete(object)
        favorites.remove(at: index)
        
        tableView.reloadData()
                
    }

}
