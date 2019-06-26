//
//  ViewController.swift
//  WeatherApp
//
//  Created by Gamarra Jimenez, Luis A. on 6/26/19.
//  Copyright © 2019 Gamarra Jimenez, Luis A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let darkSkyUrl: String = "https://api.darksky.net/forecast/{api-key}/47.6057666,-122.3330932"
    let degreeSymbol: String = "°"
    var currentTemperature: String = String()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureMetric: UILabel!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var getTemperatureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLabel.text = ""
        
        temperatureLabel.text = "--"
        temperatureMetric.text = "--"
        
        getTemperatureButton.layer.cornerRadius = 10
        
    }

    @IBAction func getTemperature(_ sender: Any) {
        getTemperatureButton.isEnabled = false
        getTemperatureButton.backgroundColor = .darkGray
        temperatureLabel.text = "--"
        temperatureMetric.text = "--"
        
        guard let url = URL(string: darkSkyUrl) else {
            debugLabel.textColor = .red
            debugLabel.text = "Unable to create URL"
            fatalError()
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let responseData = data {
                do {
                    let deserializedJson = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                    guard let jsonBody = deserializedJson,
                        let currentWeather = jsonBody["currently"] as? [String: Any],
                        let temp = currentWeather["apparentTemperature"] as? Double else {
                            fatalError()
                    }
                    
                    DispatchQueue.main.async {
                        self.temperatureLabel.text = "\(String(format: "%.1f", temp))\(self.degreeSymbol)"
                        self.temperatureMetric.text = "Fahrenheit"
                        self.getTemperatureButton.backgroundColor = UIColor(displayP3Red: 129, green: 170, blue: 131, alpha: 0)
                        self.getTemperatureButton.isEnabled = true
                        self.getTemperatureButton.backgroundColor = .white
                    }
                    
                } catch let error {
                    self.debugLabel.text = "There was an error while deserializing JSON response: \(error)"
                }
            }
        }
        
        task.resume()
    }
    
}

