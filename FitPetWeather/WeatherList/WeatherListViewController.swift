//
//  WeatherListViewController.swift
//  FitPetWeather
//
//  Created by SatGatLee on 2021/08/22.
//

import UIKit


class WeatherListViewController: UIViewController {
  lazy var loadingView: UIActivityIndicatorView = UIActivityIndicatorView().then {
    $0.style = .large
    $0.color = .black
  }
  
  lazy var weatherListTable: UITableView = UITableView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.register(WeatherListTableViewCell.self, forCellReuseIdentifier: WeatherListTableViewCell.cellIdentifier)
    $0.rowHeight = 100
    $0.dataSource = self
    $0.delegate = self
  }
  
  private let viewModel: WeatherListViewModel = WeatherListViewModel()
  private let disposeBag: DisposeBag = DisposeBag()
  
  private var weatherList: BehaviorRelay<[CityWeatherList]> = BehaviorRelay<[CityWeatherList]>(value: [])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layoutSetup {
      self.bind()
    }
  }
}

extension WeatherListViewController {
  private func layoutSetup(onCompleted: @escaping (() -> Void)) {
    view.addSubview(weatherListTable)
    view.addSubview(loadingView)
    
    constrain(weatherListTable) {
      $0.edges == $0.superview!.edges
    }
    constrain(loadingView) {
      $0.center == $0.superview!.center
      $0.width == 200
      $0.height == 200
    }
    
    loadingView.startAnimating()
    
    onCompleted()
  }
  
  private func bind() {
    viewModel.input.getCitysWeather()
    
    viewModel.onFetchedData.asDriver(onErrorJustReturn: [])
      .drive(onNext: { [weak self] list in
        guard let self = self else {return}
        
        self.weatherList.accept(self.weatherList.value + list)
      }).disposed(by: disposeBag)
    
    weatherList.filter{!$0.isEmpty}.asDriver(onErrorJustReturn: [])
      .drive(onNext: { [weak self] list in
        guard let self = self else {return}
        self.loadingView.stopAnimating()
        self.weatherListTable.reloadData()
      }).disposed(by: disposeBag)
  }
}
extension WeatherListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let weatherSection: CityWeatherList = self.weatherList.value[section]
    return weatherSection.weatherList.count
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 70
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view: CityHeaderView = CityHeaderView(text: self.weatherList.value[section].cityName)
    view.addBottomBorderWithColor(color: .black)
    view.tag = section
    return view
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.weatherList.value.count //3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: WeatherListTableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherListTableViewCell.cellIdentifier, for: indexPath) as? WeatherListTableViewCell else { return UITableViewCell() }
    let section: CityWeatherList = self.weatherList.value[indexPath.section]
    cell.cityName = self.weatherList.value[indexPath.section].cityName
    cell.config(weather: section.weatherList[indexPath.row])
    return cell
  }
}
