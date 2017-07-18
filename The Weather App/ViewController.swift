//
//  ViewController.swift
//  The Weather App
//
//  Created by Serkan Ozdemir on 7/2/17.
//  Copyright © 2017 Serkan Ozdemir. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    let urlBase:String = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22{QUERY}%22)%20and%20u%3D'c'&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    
    
    // asd  
    
    @IBAction func getWeather(_ sender: Any) {
        
        
        guard let textSearch = cityTextField.text else {
            btnSubmit.isHidden = true
            return
        }
        btnSubmit.isHidden = false
        
        
        let urlQuery = urlBase.replacingOccurrences(of: "{QUERY}", with: textSearch)
        
        guard  let theURL = URL(string: urlQuery) else {
            btnSubmit.isHidden = true
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.resultLabel.text = ""
        
        let request = NSMutableURLRequest(url: theURL)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                let json = try! JSON(data: data)
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                guard let temp = json["query"]["results"]["channel"]["item"]["condition"]["temp"].string else {
                    // uyarı mesajı
                    return
                }
                
                guard let currentTempInteger = Int(temp) else { return }
                
                self.changeBackground(temp: currentTempInteger)
                self.writeToLabel(str:temp)
                
            }
            
        }
        
        task.resume()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        cityTextField.resignFirstResponder()
        return true
    }
    
    
}


extension ViewController {
    
    
    func writeToLabel(str:String) {
        self.resultLabel.text = str
    }
    
    func changeBackground(temp:Int) {
        
    }
    
}





