//
//  SignupDinerViewController.swift
//  anjoui
//
//  Copyright (c) 2015 anjoui. All rights reserved.
//

import UIKit


class SignupDinerViewController: UIViewController {
    
    var client = MSClient?()
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBAction func dinerSignup(sender: UIButton) {
        let user_first_name:String = (txtFirstName.text! as String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let user_last_name:String = (txtLastName.text! as String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let user_email:String = (txtEmail.text! as String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let hashed_user_pass:String = ("Add some salt" + (txtPassword.text! as String) + "maybe some pepper").MD5()
        let user_phone_number:String = txtPhoneNumber.text!
        let user_address:String = txtAddress.text! as String
        
        if (user_first_name == "" || user_last_name == "" || user_email == "" || hashed_user_pass == "") {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Required fields blank"
            alertView.message = "Please fill First Name, Last Name, Email, and Password fields"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if (!user_email.isValidEmail()) {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Invalid email"
            alertView.message = "Email must be in the format: example@anjoui.com"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if (user_phone_number != "" && !user_phone_number.isValidPhoneNumber()) {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Invalid phone number"
            alertView.message = "Phone number must be 10 numeric digits without any special or alphabetical characters."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            let usertable = self.client!.tableWithName("users")
            let new_user = ["first": user_first_name,
                            "last": user_last_name,
                            "email": user_email,
                            "password": hashed_user_pass,
                            "phone_number": user_phone_number,
                            "address": user_address,
                            "profile": "diner"]
                        
            // check if email is in data base
            let userCheckPredicate = NSPredicate(format: "email == %@", user_email)
            usertable!.readWithPredicate(userCheckPredicate, completion: {
                (results, error) in
                if (error != nil)  {
                    NSLog(String(format: "%@", error.debugDescription))
                }
                
                if (results.items.count == 0) {
                    usertable.insert(new_user) {
                        (insertedItem, error) in
                        if (error != nil) {
                            print("Error" + error.description);
                        } else {
                            print("Item inserted, id: " + (insertedItem["id"] as! String))
                            self.performSegueWithIdentifier("diner_signup", sender: nil)
                            let alertView:UIAlertView = UIAlertView()
                            alertView.title = "Welcome to anjoui!"
                            alertView.message = "Congratulations! Your diner account was created successfully."
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                        }
                    }
                } else {
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Email already exists"
                    alertView.message = "This email already exists. Please use another email or log in."
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.client = MSClient(
            applicationURLString:"https://anjoui-test-ale.azure-mobile.net/",
            applicationKey:"EVLaGLPcRrWygXxmjjpYFviRlsfUgE86"
        )
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
