//
//  ScheduleViewController.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/10/13.
//

import UIKit
import FSCalendar
import Then

class ScheduleViewController: UIViewController {

    let calendar = FSCalendar().then{
        $0.scrollDirection = .vertical
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.addSubview(calendar)
        calendarLayout()
        }
    
    func calendarLayout(){
        calendar.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(view.safeAreaInsets.top).offset(20)
            $0.bottom.equalToSuperview().offset(-340)
            
        }
    }
    }
