//
//  WeatherNetwork.swift
//  FitPetWeather
//
//  Created by SatGatLee on 2021/08/22.
//

import Foundation

class WeatherNetwork {
  static let SI: WeatherNetwork = WeatherNetwork()
  
  private var baseURL: String = ""
  var imageURL: String = ""
  init() {
    urlParser()
  }
}
extension WeatherNetwork {
  private func urlParser() {
    if let infoDic : [String : Any] = Bundle.main.infoDictionary {
      if let url: String = infoDic["ApiBaseURL"] as? String,
         let imageUrl: String = infoDic["weatherImageUrl"] as? String {
        baseURL = url
        imageURL = imageUrl
      }
    }
  }
  
  
  func getCityEarthId(city: CityList) -> Observable<CityEarthId> {
    return Observable<CityEarthId>.create { observer in
      let str: String = self.baseURL + "search/?query=\(city.rawValue)"
      guard let encodingStr: String = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ,
            let url: URL = URL(string: encodingStr) else {
        return Disposables.create()
      }

      AF.request(url, method: .get).responseJSON { (response) in
        switch response.result {
        case .success(_):
          guard let json = response.value as? [AnyObject] else { return }
          
          guard let jsonData = json.first as? [String : Any],let data: CityEarthId = Mapper<CityEarthId>().map(JSON: jsonData) else { return }
          data.cityName = city.rawValue
          observer.onNext(data)
          observer.onCompleted()
        case .failure(let msg): iPrint(msg)
        }
      }
      return Disposables.create()
    }
  }
  func getCityWeatherList(city: CityEarthId) -> Observable<CityWeatherList> {
    return Observable<CityWeatherList>.create { observer in
      let str: String = self.baseURL + "\(city.woeid)"
      guard let encodingStr: String = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ,
            let url: URL = URL(string: encodingStr) else {
        return Disposables.create()
      }

      AF.request(url, method: .get).responseJSON { (response) in
        switch response.result {
        case .success(_):
          
          guard let json = response.value as? [String : Any],let data: CityWeatherList = Mapper<CityWeatherList>().map(JSON: json) else { return }
          
          data.cityName = city.cityName
          observer.onNext(data)
          observer.onCompleted()
        case .failure(let msg): iPrint(msg)
        }
      }
      
      return Disposables.create()
    }
  }
}
