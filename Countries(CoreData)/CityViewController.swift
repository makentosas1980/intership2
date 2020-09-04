//
//  CityViewController.swift
//  Countries(CoreData)
//
//  Created by Tomas Sukys on 2020-09-03.
//  Copyright © 2020 Tomas Sukys.lt. All rights reserved.
//

import CoreData
import UIKit

class CityViewController: UIViewController {
    @IBOutlet weak var cityInputLabel: UITextField!
    @IBOutlet weak var visitsInputLabel: UITextField!
    @IBOutlet weak var updateButtonLabel: UIButton!
    
    var cityName = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var city:[City] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = cityName
        updateButtonLabel.layer.cornerRadius = 10
        
        fetchCity()
        
        cityInputLabel.text = city[0].name
        visitsInputLabel.text = String(city[0].visits)
        
        hideKeyboardWhenTappedAround()
    }
    
    func fetchCity() {
        do {
            let request = City.fetchRequest() as NSFetchRequest<City>
            let pred = NSPredicate(format: "name Contains '\(cityName)'")
            request.predicate = pred
            city = try context.fetch(request)
            
            try self.context.save()
        } catch {
            print("Cound not find city")
        }
    }

    @IBAction func updateButtonTapped(_ sender: Any) {
        do {
            city[0].name = cityInputLabel.text!
            city[0].visits = Int64(visitsInputLabel.text!)!
            
            try self.context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Data can not be saved")
        }
        
    }
    
}

