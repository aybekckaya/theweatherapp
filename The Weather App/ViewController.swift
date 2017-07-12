//
//  ViewController.swift
//  The Weather App
//
//  Created by Serkan Ozdemir on 7/2/17.
//  Copyright © 2017 Serkan Ozdemir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBAction func getWeather(_ sender: Any) {
    
        if let url = URL(string:"http://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var message = ""
            
            if error != nil {
                
                print(error)
                
            } else {
                
                if let unwrappedData = data {
                    
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 1 {
                            
                            stringSeparator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 1 {
                                
                                message = newContentArray[0].replacingOccurrences(of: "&deg;C", with: "°")
                                
                                print(message)
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    
                    
                }
                
                if message == "" {
                    
                    message = "There weather there could't be found. Please try different city."
                    
                }
                
                DispatchQueue.main.sync(execute: {
                    
                    self.resultLabel.text = message
                    
                })
                
            }
            
        }
        
        task.resume()

            
        } else {
        
            resultLabel.text = "There weather there could't be found. Please try different city."
        
        }
        
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

