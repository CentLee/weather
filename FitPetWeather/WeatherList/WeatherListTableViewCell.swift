//
//  WeatherListTableViewCell.swift
//  FitPetWeather
//
//  Created by SatGatLee on 2021/08/22.
//

import Foundation

class WeatherListTableViewCell: UITableViewCell {
  static let cellIdentifier: String = String(describing: WeatherListTableViewCell.self)
  
  var cityName: String = ""
  
  lazy var currentDate: UILabel = UILabel().then {
    $0.textColor = .gray
    $0.font = UIFont.boldSystemFont(ofSize: 15)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  lazy var currentWeatherImage: UIImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  lazy var currentWeatherTitle: UILabel = UILabel().then {
    $0.textColor = .gray
    $0.font = UIFont.boldSystemFont(ofSize: 13)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  lazy var currentWeatherMaxAndMin: UILabel = UILabel().then {
    $0.textColor = .gray
    $0.font = UIFont.boldSystemFont(ofSize: 13)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.backgroundColor = .lightGray
    layoutSetup()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension WeatherListTableViewCell {
  private func layoutSetup() {
    self.contentView.translatesAutoresizingMaskIntoConstraints = false
    [currentDate, currentWeatherImage, currentWeatherTitle, currentWeatherMaxAndMin]
      .forEach { self.contentView.addSubview($0) }
    
    constrain(contentView) {
      $0.edges == $0.superview!.edges
    }
    
    constrain(currentDate) {
      $0.left == $0.superview!.left + 5
      $0.top == $0.superview!.top + 5
      $0.height == 30
    }
    constrain(currentWeatherImage, currentDate) {
      $0.left == $1.left
      $0.top == $1.bottom + 3
      $0.bottom == $0.superview!.bottom - 5
      $0.width == 50
    }
    constrain(currentWeatherTitle, currentWeatherImage, currentWeatherMaxAndMin) {
      $0.left == $1.right + 3
      $0.bottom == $1.bottom
      $0.right == $2.left - 10
    }
    constrain(currentWeatherMaxAndMin, currentWeatherTitle) {
      $0.right == $0.superview!.right - 3
      $0.bottom == $1.bottom
    }
  }
  
  func config(weather: CityWeatehrData) {


    currentDate.text = dateFormatting(weatherInfo: weather)
    currentWeatherImage.URLString(urlString: weather.weatherImageUrl)
    currentWeatherTitle.text = weather.weatherName
    currentWeatherMaxAndMin.text = weather.weatherTemperature
  }
  
  func dateFormatting(weatherInfo: CityWeatehrData) -> String {
    let current: Date = Date.init()
    let formatter: DateFormatter = DateFormatter().then {
      $0.dateFormat = "YYYY-MM-dd"
    }
    guard let date: Date = formatter.date(from: weatherInfo.weatherDate) else {return ""}
    var resultDate: String = ""
    if cityName == "Seoul" {
      if current.day == date.day {
        resultDate = "Today"
      } else if current.day + 1 == date.day {
        resultDate = "Tomorrow"
      } else {
        resultDate = date.dayName + " \(date.day) " + date.monthName
      }
    } else {
      if current.day - 1 == date.day {
        resultDate = "Today"
      } else if current.day == date.day {
        resultDate = "Tomorrow"
      } else {
        resultDate = date.dayName + " \(date.day) " + date.monthName
      }
    }
    return resultDate
  }
}

