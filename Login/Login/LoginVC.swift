//
//  LoginVC.swift
//  Login
//
//  Created by Aluno Mack on 24/04/19.
//  Copyright © 2019 MaatheusGois.Academy.Storybord.Trainer. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    func postRequest(email: String, password: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["email": email, "senha": password]
        
        //create the url with NSURL
        let url = URL(string: "https://first-app-academy.herokuapp.com/api/login")!

        //create the session object
        let session = URLSession.shared

        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {

            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body

        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            

            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }
            
            do {
                //create json object from data
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
//                print(json)
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
//    @objc func submitAction(_ sender: UIButton) {
//        //call postRequest with username and password parameters
//        postRequest(username: "username", password: "password") { (result, error) in
//            if let result = result {
//                print("success: \(result)")
//            } else if let error = error {
//                print("error: \(error.localizedDescription)")
//            }
//        }
//
//    }
    
    
    @IBAction func btnActionLogin(_ sender: Any) {
        
        
        let group = DispatchGroup() // initialize the async
        
        group.enter() // wait
        postRequest(email: "admin@admin.admin", password: "admin") { (result, error) in
            if let result = result {
                print("success: \(result)")
                group.leave() // signal
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        group.notify(queue: .main) {
            // do something here when loop finished
            UserDefaults.standard.set(true, forKey: "status")
            Switcher.updateRootVC()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
