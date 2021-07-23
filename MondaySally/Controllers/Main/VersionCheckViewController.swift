//
//  VersionCheckViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/24.
//

import UIKit
import Alamofire

class VersionCheckViewController: UIViewController {

    @IBOutlet weak var versionSallyImageView: UIImageView!
    @IBOutlet weak var notationLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    private var appVersionUrl = "\(Constant.BASE_URL)/app"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.versionCheck()
    }
    
    private func versionCheck(){
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        guard let version = version else { return }
        self.versionLabel.text = "현재 버전 \(version)"
        self.requestFetchAppVersion { [weak self] response, error in
            guard let strongself = self else { return }
            if error != nil { return }
            guard let appstoreVersion = response?.result.version else { return }
            DispatchQueue.main.async {
                print("서버에 등록된 version: \(appstoreVersion)")
                if version == appstoreVersion {
                    strongself.versionSallyImageView.isHighlighted = false
                    strongself.notationLabel.text = "최신 버전을 사용 중입니다."
                }else {
                    strongself.versionSallyImageView.isHighlighted = true
                    strongself.notationLabel.text = "업데이트가 필요합니다."
                }
            }
        }
    }
    
}

extension VersionCheckViewController{
    //앱 버전확인
    func requestFetchAppVersion(completion: @escaping (AppVersionResponse?, Error?) -> ()) {
        let url = "\(appVersionUrl)/ios"

        AF.request(url, method: .get, parameters: nil,encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: AppVersionResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess{
                        completion(response, nil)
                    }else{
                        completion(response, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
