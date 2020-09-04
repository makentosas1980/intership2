//
//  AddCountryViewController.swift
//  Countries(CoreData)
//
//  Created by Tomas Sukys on 2020-08-31.
//  Copyright © 2020 Tomas Sukys.lt. All rights reserved.
//

import UIKit
import CoreData

class AddCountryViewController: UIViewController {
    
    // MARK: - outlets
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var visited: UITextField!
    @IBOutlet weak var saveButtonLabel: UIButton!
    
    
    // MARK: - variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add new country form"
        saveButtonLabel.layer.cornerRadius = 10
        
        hideKeyboardWhenTappedAround()
        
    }
    
    //Save input details on click button "Save"
    @IBAction func saveDetails(_ sender: Any) {
        //check that fields are not empty
        if country.text != "" && city.text != "" && visited.text != "" {
            let newCountry = Country(context: context)
            newCountry.name = country.text!

            let newCity = City(context: context)
            newCity.name = city.text!
            newCity.visits = Int64(visited.text!)!

            newCountry.addToCities(newCity)

            do {
                try context.save()
            } catch {
                print("Could not save the data")
            }

            //dismiss viewController
            navigationController?.popViewController(animated: true)
        } else {
            //Show alert if one of fields is empty
            showAlert()
        }
    }
    
    //Create alert
    func showAlert() {
        let ac = UIAlertController(title: "Warning", message: "Please fill in all fields", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        present(ac, animated: true)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}
