//
//  WeatherListViewModel.swift
//  FitPetWeather
//
//  Created by SatGatLee on 2021/08/22.
//

import Foundation


protocol WeatherListViewModelInput {
  func getCitysWeather()
}
protocol WeatherListViewModelOutput {
  var onFetchedData: PublishSubject<[CityWeatherList]> {get set}
}

protocol WeatherListViewModelType {
  var input: WeatherListViewModelInput {get}
  var output: WeatherListViewModelOutput {get}
}

class WeatherListViewModel: WeatherListViewModelType, WeatherListViewModelInput, WeatherListViewModelOutput {
  var input: WeatherListViewModelInput { return self }
  var output: WeatherListViewModelOutput { return self }
  
  var onFetchedData: PublishSubject<[CityWeatherList]> = PublishSubject()

  private let disposeBag: DisposeBag = DisposeBag()
}
extension WeatherListViewModel {
  func getCitysWeather() {
    var cityEarthIds: [CityEarthId] = []
    
    Observable.from(CityList.arrayCity).enumerated()
      .concatMap { (_, city) -> Observable<CityEarthId> in
        return WeatherNetwork.SI.getCityEarthId(city: city)
      }
      .subscribe(onNext: { (city) in
        cityEarthIds.append(city)
      }, onCompleted: {
        iPrint(cityEarthIds.count)
        self.eachCityWeather(list: cityEarthIds)
      }).disposed(by: disposeBag)
  }
  
  private func eachCityWeather(list: [CityEarthId]) {
    var citysWeatherList: [CityWeatherList] = []
    
    Observable.from(list).enumerated()
      .concatMap { (_, city) -> Observable<CityWeatherList> in
        return WeatherNetwork.SI.getCityWeatherList(city: city)
      }
      .subscribe(onNext: { (city) in
        citysWeatherList.append(city)
      }, onCompleted: {
        self.onFetchedData.onNext(citysWeatherList)
      }).disposed(by: disposeBag)
  }
}
