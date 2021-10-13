//
//  HistoryViewController.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/10/13.
//

import UIKit
import Then
import SnapKit

class HistoryViewController: UIViewController {

    let testLabel = UILabel().then{
        $0.text = "여기는 HistoryViewController입니다."
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(testLabel)
        testLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
