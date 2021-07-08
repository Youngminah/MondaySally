//
//  DataService.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//
import Foundation
import Alamofire

struct DataService {
    
    // MARK: - Singleton
    static let shared = DataService()
    
    
    // MARK: - URL
    private var appVersionUrl = "\(Constant.BASE_URL)/app"
    private var teamCodeUrl = "\(Constant.BASE_URL)/teamCode"
    private var autoLoginUrl = "\(Constant.BASE_URL)/auto-login"
    private var myProfileUrl = "\(Constant.BASE_URL)/mypage"
    private var resignationUrl = "\(Constant.BASE_URL)/out"
    
    
    // MARK: - 프로필이나 로그인 관련 Services
    //앱 버전확인
    func requestFetchAppVersion(with teamCode: String, completion: @escaping (AppVersion?, Error?) -> ()) {
        let url = "\(appVersionUrl)/ios"

        AF.request(url, method: .get, parameters: nil,encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: AppVersionResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess{
                        completion(response.result, nil)
                    }else{
                        completion(response.result, nil)
                        print(response.message)
                    }
                case .failure(let error):
                    completion(nil, error)
                    print("서버와의 연결이 원활하지 않습니다")
                    print(error.localizedDescription)
                }
            }
    }
    
    //팀코드로 jwt발급
    func requestFetchTeamCode(with teamCode: String, completion: @escaping (TeamCodeResponse?, Error?) -> ()) {
        let url = "\(teamCodeUrl)?teamCode=\(teamCode)&companyIdx=2&memberID=2"

        AF.request(url, method: .post, parameters: nil,encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: TeamCodeResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess{
                        completion(response, nil)
                    }else{
                        completion(response, nil)
                        print(response.message)
                    }
                case .failure(let error):
                    completion(nil, error)
                    print("서버와의 연결이 원활하지 않습니다")
                    print(error.localizedDescription)
                }
            }
    }
    
    //자동 로그인
    func requestFetchAutoLogin(with teamCode: String, completion: @escaping (AutoLoginResponse?, Error?) -> ()) {
        let url = "\(autoLoginUrl)"

        AF.request(url, method: .get, parameters: nil,encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: AutoLoginResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess{
                        completion(response, nil)
                    }else{
                        completion(response, nil)
                        print(response.message)
                    }
                case .failure(let error):
                    completion(nil, error)
                    print("서버와의 연결이 원활하지 않습니다")
                    print(error.localizedDescription)
                }
            }
    }
    
    //프로필 조회
    func requestFetchMyProfile(with teamCode: String, completion: @escaping (MyProfileInfo?, Error?) -> ()) {
        let url = "\(myProfileUrl)"

        AF.request(url, method: .get, parameters: nil,encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: MyProfileResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess{
                        completion(response.result, nil)
                    }else{
                        completion(response.result, nil)
                        print(response.message)
                    }
                case .failure(let error):
                    completion(nil, error)
                    print("서버와의 연결이 원활하지 않습니다")
                    print(error.localizedDescription)
                }
            }
    }
    
    
    //퇴사신청
    func requestFetchResignation(with teamCode: String, completion: @escaping (ResignationRequestResponse?, Error?) -> ()) {
        let url = "\(resignationUrl)"

        AF.request(url, method: .post, parameters: nil,encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: ResignationRequestResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess{
                        completion(response, nil)
                    }else{
                        completion(response, nil)
                        print(response.message)
                    }
                case .failure(let error):
                    completion(nil, error)
                    print("서버와의 연결이 원활하지 않습니다")
                    print(error.localizedDescription)
                }
            }
    }
    
}
