//
//  LoginController.swift
//  Technical Test Venturas
//
//  Created by Faizul Karim on 7/11/21.
//

import UIKit

class CreateAccount: UIViewController {
    //MARK:- Outlet
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btneye: UIButton!
    
    //MARK:- Class Variable
    var isPasswordHide : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()

    }
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    //MARK:- Custom Method
    func setUpView() {
        self.btnCreateAccount.roundCornersToBtn(corners: .allCorners, radius: 8.0)
    }
    

    //MARK:- Action Method
    @IBAction func ShowPassword(_ sender: Any) {
        if self.isPasswordHide {
            self.password.isSecureTextEntry = false
            self.isPasswordHide = false
        }else{
            self.password.isSecureTextEntry = true
            self.isPasswordHide = true
        }
    }
    

}
