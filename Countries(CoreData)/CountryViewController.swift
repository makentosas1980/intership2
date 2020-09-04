//
//  CountryViewController.swift
//  Countries(CoreData)
//
//  Created by Tomas Sukys on 2020-08-31.
//  Copyright © 2020 Tomas Sukys.lt. All rights reserved.
//

import UIKit
import CoreData

class CountryViewController: UIViewController {
    
    // MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cityItems:[City] = []
    var countryItem:[Country] = []
    var cities = [City]()
    var countryName = ""
    var submitButton = UIAlertAction()
    var cityTextFieldInput: Bool!
    var visitsTextFieldInput: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = countryName

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add city", style: .plain, target: self, action: #selector(addNewCity))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchCities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCities()
    }
    
    func fetchCities() {
        do {
            cities.removeAll()
            cityItems = try context.fetch(City.fetchRequest())
            for item in cityItems {
                if item.country.name == countryName {
                    cities.append(item)
                }
            }
            tableView.reloadData()
        } catch {
            print("Could not fetch any data")
        }
    }
    
    
    //ADD CITY
    @objc func addNewCity() {
        let ac = UIAlertController(title: "New City", message: "Fill details below", preferredStyle: .alert)
        ac.addTextField { (textfield) in
            textfield.placeholder = "name of city"
        }
        ac.addTextField { (textfield) in
            textfield.placeholder = "visited"
            textfield.keyboardType = .numberPad
        }
        
        let cityTextField = ac.textFields![0]
        let visitedTextField = ac.textFields![1]
        
        
        
        submitButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if cityTextField.text != "" && visitedTextField.text != "" {
                let newCity = City(context: self.context)
                newCity.name = cityTextField.text!
                newCity.visits = Int64(visitedTextField.text!)!
                
                newCity.country = self.countryItem[0]
                
                do {
                    try self.context.save()
                } catch {
                    print("Saving city error")
                }
                
                self.fetchCities()
            } else {
            
            }
            
        }
        
        submitButton.isEnabled = false
        
        cityTextField.addTarget(self, action: #selector(cityTextFieldDidChange(_:)), for: .editingChanged)
        visitedTextField.addTarget(self, action: #selector(visitsTextFieldDidChange(_:)), for: .editingChanged)
        
        ac.addAction(submitButton)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func cityTextFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 0 {
            cityTextFieldInput = false
        } else {
            cityTextFieldInput = true
        }
        
        if cityTextFieldInput == true && visitsTextFieldInput == true {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    
    @objc func visitsTextFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 0 {
            visitsTextFieldInput = false
        } else {
            visitsTextFieldInput = true
        }
        
        if cityTextFieldInput == true && visitsTextFieldInput == true {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }

}

extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].name
        cell.detailTextLabel?.text = "Visits: \(String(cities[indexPath.row].visits))"
        cell.detailTextLabel?.textColor = .blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "City") as? CityViewController {
            vc.cityName = cities[indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //DELETE CITY
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let cityToRemove = self.cities[indexPath.row]
            self.context.delete(cityToRemove)
            
            do {
                try self.context.save()
            } catch {
                print("No chance to delete it!!!!")
            }
            
            self.fetchCities()
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }

}
