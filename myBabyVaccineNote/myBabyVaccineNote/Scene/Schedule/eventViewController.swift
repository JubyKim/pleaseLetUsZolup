//
//  eventViewController.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/11/02.
//

import UIKit

class eventViewController: UIViewController {
    
    let dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    

}
