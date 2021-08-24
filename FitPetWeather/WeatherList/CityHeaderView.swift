//
//  CityHeaderView.swift
//  FitPetWeather
//
//  Created by SatGatLee on 2021/08/24.
//

import Foundation

class CityHeaderView: UIView {
  
  lazy var title: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.boldSystemFont(ofSize: 17)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
  }
  
  convenience init(text: String) {
    self.init(frame: .zero)
    title.text = text
    backgroundColor = .lightGray
    layoutSetup()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    if self.tag == 0 {
      self.addBottomBorderWithColor(color: .black)
    } else {
      self.addBottomBorderWithColor(color: .black)
      self.addTopBorderWithColor(color: .black)
    }
  }
}
extension CityHeaderView {
  private func layoutSetup() {
    addSubview(title)
    
    constrain(title) {
      $0.centerY == $0.superview!.centerY
      $0.left == $0.superview!.left + 3
    }
  }
}
