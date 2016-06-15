//
//  ViewController.swift
//  IOSChallange
//
//  Created by Daniel Klinkert on 6/13/16.
//  Copyright © 2016 Daniel Klinkert H. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
import SwiftDate

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherDate: UILabel!
    @IBOutlet var iconWeather: UIImageView!
    @IBOutlet var todayContainer: UIView!
    @IBOutlet var weatherDescription: UILabel!
    
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var humidil: UILabel!
    
    
    @IBOutlet var fisrtDayName: UILabel!
    @IBOutlet var secondDayName: UILabel!
    @IBOutlet var thirdDayName: UILabel!
    @IBOutlet var fourthDayName: UILabel!
    @IBOutlet var fifthDayName: UILabel!
    
    @IBOutlet var firstDayTemp: UILabel!
    @IBOutlet var secondDayTemp: UILabel!
    @IBOutlet var thirdDayTemp: UILabel!
    @IBOutlet var fourthDayTemp: UILabel!
    @IBOutlet var fifthDayTemp: UILabel!
    
    @IBOutlet var icon1: UIImageView!
    
    @IBOutlet var icon5: UIImageView!
    @IBOutlet var icon4: UIImageView!
    @IBOutlet var icon3: UIImageView!
    @IBOutlet var icon2: UIImageView!
    let locationManager         = CLLocationManager()
    var currentLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        todayContainer.alpha = 0.5
        getWeatherFromLocation()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getWeatherFromLocation() {
        
        SVProgressHUD.showWithStatus("getting Weather")
        guard let location = currentLocation else {
            return
        }
        DKWeather.getWeather(location) { (weather,error) in
            
            if error == nil {
                self.setupViewWithWeather(weather!)
                SVProgressHUD.dismiss()
            }else {
                SVProgressHUD.dismiss()
            }
            
        }
    }
    
    
    func setupViewWithWeather(weather:[DKWeather]) {
        
        temperatureLabel.text   = "\(weather.first!.weatherTemperature)" + "º"
        weatherDate.text        = weather.first!.weatherDate.toString(.Custom("EEEE, MMM dd"))
        weatherDescription.text = weather.first?.weatherDescription
        
        
        humidil.text            = ((weather.first!.humidity * 100).doubleToString()) + "%"
        windSpeed.text          = weather.first!.windSpeed.doubleToString() + " MPH"
        
        fisrtDayName.text       = weather.first?.weatherDate.toString(.Custom("EEE"))
        secondDayName.text      = weather[1].weatherDate.toString(.Custom("EEE"))
        thirdDayName.text       = weather[2].weatherDate.toString(.Custom("EEE"))
        fourthDayName.text      = weather[3].weatherDate.toString(.Custom("EEE"))
        fifthDayName.text       = weather[4].weatherDate.toString(.Custom("EEE"))
        
        
        
        
        firstDayTemp.text       = weather.first!.weatherTemperature!.doubleToString() + "º"
        secondDayTemp.text      = weather[1].weatherTemperature.doubleToString() + "º"
        thirdDayTemp.text       = weather[2].weatherTemperature.doubleToString() + "º"
        fourthDayTemp.text      = weather[3].weatherTemperature.doubleToString() + "º"
        fifthDayTemp.text       = weather[4].weatherTemperature.doubleToString() + "º"
        
        let lower : UInt32 = 1
        let upper : UInt32 = 4
        var randomNumber = arc4random_uniform(upper - lower) + lower
        icon1.image         = UIImage(named: "icon\(randomNumber)")
        iconWeather.image   = UIImage(named: "icon\(randomNumber)")
        randomNumber = arc4random_uniform(upper - lower) + lower
        icon2.image         = UIImage(named: "icon\(randomNumber)")
        randomNumber = arc4random_uniform(upper - lower) + lower
        icon3.image         = UIImage(named: "icon\(randomNumber)")
        randomNumber = arc4random_uniform(upper - lower) + lower
        icon4.image         = UIImage(named: "icon\(randomNumber)")
        randomNumber = arc4random_uniform(upper - lower) + lower
        icon5.image         = UIImage(named: "icon\(randomNumber)")

        
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first!
        getWeatherFromLocation()
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)  in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                SVProgressHUD.dismiss()
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.title = pm.locality!.stringByFoldingWithOptions(NSStringCompareOptions.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale()) + ","  + pm.ISOcountryCode!.stringByFoldingWithOptions(NSStringCompareOptions.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
                
                SVProgressHUD.dismiss()

            }
            else {
                print("Problem with the data received from geocoder")
            }
        })

        manager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error" + error.localizedDescription)
        SVProgressHUD.showInfoWithStatus(error.localizedDescription)
    }


    
    @IBAction func refreshAction(sender: AnyObject) {
        getWeatherFromLocation()
    }

}

