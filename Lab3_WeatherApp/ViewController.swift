//
//  ViewController.swift
//  Lab3_WeatherApp
//
//  Created by Denish Kakadiya on 2022-07-26.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {

    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var condition: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageConfig()
        searchTextField.delegate = self
        locationManager.delegate=self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        print(textField.text ?? "")
        loadWeather(search: searchTextField.text)
        return true
    }
    
    private func imageConfig(){
        let config = UIImage.SymbolConfiguration(paletteColors:[.systemRed,.systemBlue,.systemYellow])
        weatherConditionImage.preferredSymbolConfiguration=config
        weatherConditionImage.image=UIImage(systemName: "sunrise")
    }

    @IBAction func onLocationButton(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    @IBAction func onSearchButton(_ sender: UIButton) {
        loadWeather(search: searchTextField.text)
    }
    
    private func loadWeather(search : String?){
        guard let search = search else{
            return
            
        }
//        Step 1: Get URL
        guard let url = getURl(query: search) else {
            print("Could not get URL")
            return
        }
//        Step 2: Create URLSession
        let session =  URLSession.shared
//        Step 3: Create task for session
        let dataTask = session.dataTask(with: url) { data, response, error in
            //network call finished
            print("Network Call complete")
            
            guard error == nil else{
                print("Received Error")
                return
            }
            guard let data = data else {
                print("No data found")
                return
            }
            if let weatherResponse = self.parseJson(data: data) {
                print(weatherResponse.location.name)
                print(weatherResponse.current.temp_c)
                print(weatherResponse.current.condition)
                DispatchQueue.main.async {[self] in
                    self.locLabel.text = weatherResponse.location.name
                    self.tempLabel.text="\(weatherResponse.current.temp_c)C"
                    self.condition.text="\(weatherResponse.current.condition.text)"
                    var config = UIImage.SymbolConfiguration(paletteColors: [.systemCyan,.systemYellow,.systemTeal])
                    self.weatherConditionImage.preferredSymbolConfiguration = config
                        if(weatherResponse.current.condition.code==1000)
                        {
                            config=UIImage.SymbolConfiguration(paletteColors: [.systemYellow])
                            self.weatherConditionImage.image=UIImage(systemName:"sun.max.fill")
                        }
                        if(weatherResponse.current.condition.code==1003)
                        {
                            config=UIImage.SymbolConfiguration(paletteColors: [.systemTeal])
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.fill")
                        }
                        if(weatherResponse.current.condition.code==1003)
                        {
                            config=UIImage.SymbolConfiguration(paletteColors: [.systemTeal])
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.fill")
                        }
                        if(weatherResponse.current.condition.code==1183)
                        {
                            config=UIImage.SymbolConfiguration(paletteColors: [.systemBlue,.systemGray2])
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.drizzle")
                        }
                        if(weatherResponse.current.condition.code==1183)
                        {
                            config=UIImage.SymbolConfiguration(paletteColors: [.systemCyan,.systemTeal])
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.heavyrain")
                        }
                        if(weatherResponse.current.condition.code==1210)
                        {
                            config=UIImage.SymbolConfiguration(paletteColors: [.systemPurple])
                            self.weatherConditionImage.image=UIImage(systemName:"snowflake")
                        }
                    }
                }
        }
//        Step 4 : Start the task
        dataTask.resume()
        
    }
 
    private func getURl(query: String) -> URL?{
        let baseURL = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let apiKey = "c26ee4c27b8943e1bc1220256222607"
        guard let url = "\(baseURL)\(currentEndpoint)?key=\(apiKey)&q=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return nil
        }
        print(url)
        return URL(string: url)
    }
    private func parseJson(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder()
        var weather : WeatherResponse?
        do{
            weather = try decoder.decode(WeatherResponse.self, from: data)
            } catch{
                print("Error decoding")
            }
        return weather
        }
}

extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        if let location = locations.last{
            let latitude=location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            
    //        Step 1: Get URL
            guard let url = getURl(query: "\(latitude),\(longitude)") else {
                print("Could not get URL")
                return
            }
    //        Step 2: Create URLSession
            let session =  URLSession.shared
    //        Step 3: Create task for session
            let dataTask = session.dataTask(with: url) { data, response, error in
                //network call finished
                print("Network Call complete")
                guard error == nil else{
                    print("Received Error")
                    return
                }
                guard let data = data else {
                    print("No data found")
                    return
                }
                if let weatherResponse = self.parseJson(data: data) {
                    print(weatherResponse.location.name)
                    print(weatherResponse.current.temp_c)
                    print(weatherResponse.current.condition)
                    DispatchQueue.main.async {[self] in
                        self.locLabel.text = weatherResponse.location.name
                        self.tempLabel.text="\(weatherResponse.current.temp_c)C"
                        self.condition.text="\(weatherResponse.current.condition.text)"
                        var config = UIImage.SymbolConfiguration(paletteColors: [.systemCyan,.systemYellow,.systemTeal])
                        self.weatherConditionImage.preferredSymbolConfiguration = config
                            if(weatherResponse.current.condition.code==1000)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemYellow])
                                self.weatherConditionImage.image=UIImage(systemName:"sun.max.fill")
                            }
                            if(weatherResponse.current.condition.code==1003)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemTeal])
                                self.weatherConditionImage.image=UIImage(systemName:"cloud.fill")
                            }
                            if(weatherResponse.current.condition.code==1003)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemTeal])
                                self.weatherConditionImage.image=UIImage(systemName:"cloud.fill")
                            }
                            if(weatherResponse.current.condition.code==1183)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemBlue,.systemGray2])
                                self.weatherConditionImage.image=UIImage(systemName:"cloud.drizzle")
                            }
                            if(weatherResponse.current.condition.code==1183)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemCyan,.systemTeal])
                                self.weatherConditionImage.image=UIImage(systemName:"cloud.heavyrain")
                            }
                            if(weatherResponse.current.condition.code==1210)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemPurple])
                                self.weatherConditionImage.image=UIImage(systemName:"snowflake")
                            }
                        }
                    }
                }
        //        Step 4 : Start the task
                dataTask.resume()
            }
        }
    }


struct WeatherResponse: Decodable{
    let location: Location
    let current: Weather
}

struct Location: Decodable{
    let name: String
}

struct Weather: Decodable{
    let temp_c: Float
    let condition: WeatherCondition
}

struct WeatherCondition: Decodable{
    let text :  String
    let code: Int
}
