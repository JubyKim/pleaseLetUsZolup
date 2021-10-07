//
//  VaccineCollectionViewCell.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/09/29.
//

import UIKit
import Then
import SnapKit

class VaccineCollectionViewCell: UICollectionViewCell {
    let button = UIButton().then{
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    let buttonName = UILabel().then{
        $0.textColor = .black
        $0.isUserInteractionEnabled = false
    }
    
    func setupView() {
        self.addSubview(button)
        button.snp.makeConstraints{
            $0.center.bottom.top.trailing.leading.equalToSuperview()
        }
        button.addSubview(buttonName)
        buttonName.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
    }
}
