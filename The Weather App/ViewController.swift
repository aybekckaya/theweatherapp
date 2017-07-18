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
    
    let urlBase:String = "https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='{QUERY}') and u='c'&format=json&diagnostics=true&env=store://datatables.org/alltableswithkeys&callback="
    
    
    // asd
    
    @IBAction func getWeather(_ sender: Any) {
        
        
        guard let textSearch = cityTextField.text else {
            btnSubmit.isHidden = true
            return
        }
        btnSubmit.isHidden = false
        
       
        guard let urlQuery = urlBase.replacingOccurrences(of: "{QUERY}", with: textSearch).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }
        
        guard  let theURL = URL(string: urlQuery) else {
            btnSubmit.isHidden = true
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.resultLabel.text = ""
        
        let request = NSMutableURLRequest(url: theURL)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            // asd
            DispatchQueue.main.async {
                guard let data = data else { return }
                let json = try! JSON(data: data)
                print("json : \(json)")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                guard let temp = json["query"]["results"]["channel"]["item"]["condition"]["temp"].string else {
                    self.showPlaceNotFoundAlert()
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
        self.resultLabel.text = str+"\u{00B0}"
    }
    
    func changeBackground(temp:Int) {
        
    }
    
    
    
}

extension ViewController {
    
    func showPlaceNotFoundAlert() {
        showAlert(title:"Something happened" , errorMessage: "The city should be located on Earth" , doneText:"Let me try again...")
    }
    
    private func showAlert(title:String , errorMessage:String , doneText:String ) {
        // location not found alert
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: doneText, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}




