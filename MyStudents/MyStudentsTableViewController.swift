//
//  MyStudentsTableViewController.swift
//  MyStudents
//
//  Created by Sue Ceklosky on 11/13/19.
//  Copyright © 2019 susie. All rights reserved.
//

import UIKit
import CoreData

class MyStudentsTableViewController: UITableViewController {
    
    // context used to access Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // array used to store Students
    var students = [Student] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 84.0
        loadStudents()
    }

    // fetch Student data from Core Data
    func loadStudents() {
        
        // create an instance of a FetchRequest so that
        // data may be fetched from the Student entity
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
            // use context to execute fetch request
            // and store fetched students in array
            // fetch method could throw an error, so
            // it must be included in a do-catch
            students = try context.fetch(request)
        } catch {
            print("Error fetching student data from context \(error)")
        }
        
        // reload fetched data in Table View Controller
        tableView.reloadData()
    }
    
    // save Student data to Core Data
    func saveStudents (){
        do {
            // use context to execute save request
            // save method could throw an error, so
            // it must be included in a do-catch
            try context.save()
        } catch {
            print("Error saving student \(error)")
        }
        
        // reload data in Table View Controller
        tableView.reloadData()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyStudentsCell", for: indexPath)

        // Configure the cell...
        let student = students[indexPath.row]
        cell.textLabel?.text = student.fname! + " " + student.lname!
        cell.detailTextLabel!.numberOfLines = 0
        cell.detailTextLabel?.text = student.year! + "\n" + student.major!
        
        return cell
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
        // declare Text Fields for the input of the first name, last name, year, and major
        var fnameTextField = UITextField()
        var lnameTextField = UITextField()
        var yearTextField = UITextField()
        var majorTextField = UITextField()
            
        // create an Alert Controller
        let alert = UIAlertController(title: "My Students", message: "", preferredStyle: .alert)
            
        // define action that will occur when Alert
        // Controller's add button is pushed
        let action = UIAlertAction(title: "Add", style: .default, handler: { (action) in
                
            // create an instance of a Student
            let newStudent = Student(context: self.context)
                
            // get first name, last name, year, and major input by user and store them in Student
            newStudent.fname = fnameTextField.text!
            newStudent.lname = lnameTextField.text!
            newStudent.year = yearTextField.text!
            newStudent.major = majorTextField.text!
                
            // add Student into array
            self.students.append(newStudent)
                
            // save array
            self.saveStudents()
        })
            
        // disable the action that allows the user to add a Student
        action.isEnabled = false
            
        // define action that will occur when Alert
        // Controller's cancel button is pushed
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (cancelAction) in
                
        })
            
        // add the actions to the Alert Controller
        alert.addAction(action)
        alert.addAction(cancelAction)
            
        // add Text Fields to Alert Controller
        alert.addTextField(configurationHandler: { (field) in
            fnameTextField = field
            fnameTextField.placeholder = "First Name"
            fnameTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { (field) in
            lnameTextField = field
            lnameTextField.placeholder = "Last Name"
            lnameTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { (field) in
            yearTextField = field
            yearTextField.placeholder = "Year"
            yearTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
            })
        alert.addTextField(configurationHandler: { (field) in
            majorTextField = field
            majorTextField.placeholder = "Major"
            majorTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
            
        // display the Alert Controller
        present(alert, animated: true, completion: nil)
    }
        
        
    @objc func alertTextFieldDidChange () {
        
        // get a reference to the Alert Controller
        let alertController = self.presentedViewController as! UIAlertController;
        
        // get a reference to the action that allows the user to add a Student
        let action = alertController.actions[0];
        
        // get the text that has been input into the
        // Text Fields
        if let fname = alertController.textFields![0].text, let lname =  alertController.textFields![1].text, let year = alertController.textFields![2].text, let major = alertController.textFields![3].text {
            
            // trim whitespaces from the text
            let trimmedFname = fname.trimmingCharacters(in: .whitespaces)
            let trimmedLname = lname.trimmingCharacters(in: .whitespaces)
            let trimmedYear = year.trimmingCharacters(in: .whitespaces)
            let trimmedMajor = major.trimmingCharacters(in: .whitespaces)
            
            // if the trimmed text isn't empty, enable
            // the action that allows the user to add a
            // Student
            if (!trimmedFname.isEmpty && !trimmedLname.isEmpty && !trimmedYear.isEmpty && !trimmedMajor.isEmpty){
                action.isEnabled = true
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // dequeing the table row cell
        _ = tableView.dequeueReusableCell(withIdentifier: "MyStudentsCell", for: indexPath)
        
        // create 4 text fields
        var fnameTextField = UITextField()
        var lnameTextField = UITextField()
        var yearTextField = UITextField()
        var majorTextField = UITextField()
        
        // create alert controller
        let alert = UIAlertController(title: "\(students[indexPath.row].fname!) \(students[indexPath.row].lname!)", message: "", preferredStyle: .alert)
        
        // define the action that will occur when the Alert Controllers change button is pushed
        let action = UIAlertAction(title: "Change", style: .default, handler: { (action) in
            
            // get the selected Student
            let student = self.students[indexPath.row]
            
            // update selected Student based on input in Text Fields
            student.fname = fnameTextField.text
            student.lname = lnameTextField.text
            student.year = yearTextField.text
            student.major = majorTextField.text
            
            // save the updates
            self.saveStudents()
        })
        
        // define the action that will occur when the cancel button is pushed
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (cancelAction) in
        })
        
        // add actions to the alert controller
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        // add text fields to the alert controller
        alert.addTextField(configurationHandler: { (field) in
            fnameTextField = field
            fnameTextField.text = self.students[indexPath.row].fname
        })
        alert.addTextField(configurationHandler: { (field) in
            lnameTextField = field
            lnameTextField.text = self.students[indexPath.row].lname
        })
        alert.addTextField(configurationHandler: { (field) in
            yearTextField = field
            yearTextField.text = self.students[indexPath.row].year
        })
        alert.addTextField(configurationHandler: { (field) in
            majorTextField = field
            majorTextField.text = self.students[indexPath.row].major
        })
        
        // display the alert controller
        present(alert, animated: true, completion: nil)
        
        // call deselect row so that update is reflected in the table view controller
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
