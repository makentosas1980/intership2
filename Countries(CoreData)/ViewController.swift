//
//  ViewController.swift
//  Countries(CoreData)
//
//  Created by Tomas Sukys on 2020-08-31.
//  Copyright © 2020 Tomas Sukys.lt. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - outlets
    @IBOutlet weak var picker: UIPickerView!
    
    // MARK: - variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var countryItems:[Country] = []
    var cityItems:[City] = []
    var sortBy = ["Country \"A-Z\"", "Country \"Z-A\""]
    var totalVisited: Int64 = 0
    var visitArray = [Int64]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(addCountry))

        title = "My visited countries"
        
        picker.delegate = self
        picker.dataSource = self

        fetchCountries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCountries()
    }
    
    //fetch countries from coredata
    func fetchCountries() {
        do {
            countryItems = try context.fetch(Country.fetchRequest())
            cityItems = try context.fetch(City.fetchRequest())
            tableView.reloadData()
        } catch {
            print("Could not fetch any data")
        }
    }
    
    //set picker wheel picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    //number of rows in a wheel picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortBy.count
    }
    
    //title for each row in wheel picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortBy[row]
    }
    
    //Picker wheel selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 1:
            sortByNameDescend()
        default:
            sortByNameAscend()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let countryName = countryItems[indexPath.row].name
        cell.textLabel?.text = countryName.uppercased()

        countVisits(country: countryName)
        visitArray.append(totalVisited)
        
        cell.detailTextLabel?.text = "Total visits: \(String(totalVisited))"
        cell.detailTextLabel?.textColor = .gray
        
        cell.imageView?.image = UIImage(named: "\(countryName.lowercased())")
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Country") as? CountryViewController {
            vc.countryName = countryItems[indexPath.row].name
            vc.countryItem = [countryItems[indexPath.row].self]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //Count total city visits for each country
    func countVisits(country: String) {
        totalVisited = 0
        let nameOfCountry = country
        
        for item in cityItems {
            if item.country.name == nameOfCountry {
                totalVisited += item.visits
            }
        }
    }
    
    //NAVIGATE  to view "Add country"
    @objc func addCountry(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "Form") as? AddCountryViewController {
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("problem")
        }
    }
    
    //DELETE Country
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let countryToRemove = self.countryItems[indexPath.row]
            self.context.delete(countryToRemove)
            
            do {
                try self.context.save()
            } catch {
                print("Np chance to delete it!!!!")
            }
            
            self.fetchCountries()
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //Sort tableview by country name acending
    func sortByNameAscend() {
        do {
            let request = Country.fetchRequest() as NSFetchRequest<Country>
            
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            countryItems = try context.fetch(request)
            tableView.reloadSections([0], with: UITableView.RowAnimation.middle)
        } catch {
            print("Failed to load from Coredata")
        }
    }
    
    //Sort tableview by country name descending
    func sortByNameDescend() {
        do {
            let request = Country.fetchRequest() as NSFetchRequest<Country>
            
            let sort = NSSortDescriptor(key: "name", ascending: false)
            request.sortDescriptors = [sort]
            
            countryItems = try context.fetch(request)
            tableView.reloadSections([0], with: UITableView.RowAnimation.middle)
        } catch {
            print("Failed to load from Coredata")
        }
    }

    

}

