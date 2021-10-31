//
//  HistoryViewController.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/10/13.
//

import UIKit
import Then
import WebKit
import SnapKit
import Foundation
import SystemConfiguration


class HistoryViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.view.addSubview(webView)
        webView.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.bottom.top.leading.trailing.equalToSuperview()
        }
        loadUrl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
            
            print("viewDidAppear Call")
            
            checkNetworkConnect()
        }
    func checkNetworkConnect() {
            //Alert 사용한 Network Check --> viewDidAppear
            if Reachability.isConnectedToNetwork() {
                print("Network Connect")
            } else {
                print("Network Not Connect")
                
                let networkCheckAlert = UIAlertController(title: "Network Error", message: "앱 종료", preferredStyle: UIAlertController.Style.alert)
                
                networkCheckAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_: UIAlertAction!) in
                    print("App exit")
                    
                    exit(0)
                }))
                
                self.present(networkCheckAlert, animated: true, completion: nil)
            }
        }
    
    public class Reachability {
        class func isConnectedToNetwork() -> Bool {
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0,0,0,0,0,0,0,0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
                    
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
                    
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
                    
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                    return false
            }
                    
            // Working for Cellular and WIFI
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            let ret = (isReachable && !needsConnection)
                    
            return ret
        }
    }
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
       webView.reload()
    }
    
    func loadUrl() {
      view.addSubview(webView)
            
      //WKWebview Setting
      let url = URL(string: "https://nip.kdca.go.kr/irgd/index.html")
      let request = URLRequest(url: url!)
            
      webView.load(request)
            
      webView.uiDelegate = self
      webView.navigationDelegate = self
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
