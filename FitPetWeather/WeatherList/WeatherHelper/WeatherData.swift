//
//  WeatherData.swift
//  FitPetWeather
//
//  Created by SatGatLee on 2021/08/22.
//

import Foundation

enum CityList: String {
  
  case seoul = "Seoul"
  case london = "London"
  case chicago = "Chicago"
  
  static var arrayCity: [CityList] {
    return [.seoul, .london, .chicago]
  }
}

class CityEarthId: Mappable { //영화 검색 리스트
  var woeid: Int = 0
  var cityName: String = ""
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    woeid  <- map["woeid"]
  }
}


class CityWeatherList: Mappable {
  var cityName: String = ""
  var weatherList: [CityWeatehrData] = []
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    weatherList  <- map["consolidated_weather"]
  }
}

class CityWeatehrData: Mappable {
  var weatherName: String = ""
  var weatherDate: String = ""
  var weatherMax: Double = 0.0
  var weatherMin: Double = 0.0
  var weatherImage: String = ""
  
  var weatherImageUrl: String {
    return WeatherNetwork.SI.imageURL + weatherImage + ".png"
  }
  
  var weatherTemperature: String {
    return "Max:\(weatherMax.rounded())℃      " + "Min:\(weatherMin.rounded())℃"
  }
  
  var weatherDateString: String {
    let current: Date = Date.init()
    let formatter: DateFormatter = DateFormatter().then {
      $0.dateFormat = "YYYY-MM-dd"
    }
    guard let date: Date = formatter.date(from: weatherDate) else {return ""}
    if current.day == date.day {
      return "Today"
    } else if current.day + 1 == date.day {
      return "Tomorrow"
    } else {
      return date.dayName + " \(date.day) " + date.monthName
    }
  }
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    weatherName  <- map["weather_state_name"]
    weatherDate  <- map["applicable_date"]
    weatherMax  <- map["max_temp"]
    weatherMin  <- map["min_temp"]
    weatherImage  <- map["weather_state_abbr"]
  }
  
}
