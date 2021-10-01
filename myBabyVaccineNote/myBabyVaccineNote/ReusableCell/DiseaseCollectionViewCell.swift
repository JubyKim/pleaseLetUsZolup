//
//  DiseaseCollectionViewCell.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/09/29.
//

import UIKit
import Then
import SnapKit
import DLRadioButton

class DiseaseCollectionViewCell: UICollectionViewCell {
    
    let button = DLRadioButton().then{
        $0.setTitle("dididi", for: .normal)
        $0.titleLabel?.textColor  = .black
    }
    
    let buttonLabel = UILabel().then{
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    func setupView() {
        self.addSubview(button)
        
        button.snp.makeConstraints{
            $0.center.bottom.top.trailing.leading.equalToSuperview()
        }
        
        button.addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints{
            $0.center.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
