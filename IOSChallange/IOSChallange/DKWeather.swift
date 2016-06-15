//
//  DKWeather.swift
//  IOSChallange
//
//  Created by Daniel Klinkert on 6/13/16.
//  Copyright © 2016 Daniel Klinkert H. All rights reserved.
//

import UIKit

import SwiftyJSON
import ForecastIOClient
import Alamofire
import CoreLocation


class DKWeather: NSObject {
    static let kBaseUrl = "https://api.forecast.io/forecast/391fbd0f653ebb54e3f0354f6f86b5e3/"
    
    var weatherDate:NSDate!
    var weatherDescription:String!
    var iconUrl:String!
    var windSpeed:Double!
    var weatherTemperature:Double!
    var humidity:Double!
    
    
    class func entityFromData(data:DataPoint) -> DKWeather {
        
        let currentWeather = DKWeather()
        
        currentWeather.weatherDate          = NSDate(timeIntervalSince1970: Double(data.time))
        currentWeather.weatherDescription   = data.summary
        currentWeather.iconUrl              = data.icon
        currentWeather.windSpeed            = data.windSpeed
        currentWeather.weatherTemperature   = data.temperatureMax
        currentWeather.humidity             = data.humidity
        
        
        return currentWeather
        
    }
    
    class func entityFromDict(dict:JSON) -> DKWeather {
        
        
        let currentWeather = DKWeather()
        
        currentWeather.weatherDate          = NSDate(timeIntervalSince1970: dict["time"].doubleValue)
        currentWeather.weatherDescription   = dict["summary"].stringValue
        currentWeather.iconUrl              = dict.stringValue
        currentWeather.windSpeed            = dict["windSpeed"].doubleValue
        currentWeather.weatherTemperature   = dict["temperatureMax"].doubleValue
        currentWeather.humidity             = dict["humidity"].doubleValue
        
        
        return currentWeather
    }
    
    
    class func getWeather(currentLocation:CLLocation,clousure:(weather:[DKWeather]?,error:NSError?)->()) -> () {
        
        var url:String!
    
        url =  kBaseUrl + "\(currentLocation.coordinate.latitude)" + ",\(currentLocation.coordinate.longitude)"
        
        Alamofire.request(.GET, url, parameters: nil, headers:nil, encoding:.JSON)
            .validate()
            .response { request, response, data, error in
                
                if error == nil {
                    let jsonResponse = JSON(data: data!)
                    var weatherMutable = [DKWeather]()
                    
                    for (_, subJson): (String, JSON) in jsonResponse["daily"]["data"] {
                        let currentWeather = DKWeather.entityFromDict(subJson)
                        weatherMutable.append(currentWeather)
                        
                    }
                    clousure(weather: weatherMutable, error: nil)
                    
                }else {
                    var newError = error
                    let jsonResponse = JSON(data: data!)
                    if response != nil {
                        newError = NSError(domain: "Booking error", code: response!.statusCode, userInfo: [NSLocalizedDescriptionKey:jsonResponse["Message"].stringValue])
                    }
                    clousure(weather: nil, error: newError)
                }
        }
        
        
        
        
        
    }
    
    
    class func getWeatherFromCurrentLocation(currentUserLocation:CLLocation!,clousure:(weather:[DKWeather],error:NSError?)->())->() {
        
        
        
        ForecastIOClient.sharedInstance.forecast(currentUserLocation.coordinate.latitude, longitude: currentUserLocation.coordinate.longitude) { (forecast, forecastAPICalls) -> Void in
            
            
            guard let daily = forecast.daily else {
                return
            }
            
            var weatherMutable = [DKWeather]()
            
            
            for weather in daily.data! {
                
                let currentWeather = DKWeather.entityFromData(weather)
                weatherMutable.append(currentWeather)
            }
            
            clousure(weather: weatherMutable, error: nil)
            
            // do something with forecast data
        }
        
        
    }
    
    
}
