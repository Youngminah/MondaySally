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
    private var deviceTokenSaveUrl = "\(Constant.BASE_URL)/firebase"
    private var teamCodeUrl = "\(Constant.BASE_URL)/code"
    private var autoLoginUrl = "\(Constant.BASE_URL)/auto-login"
    private var myProfileUrl = "\(Constant.BASE_URL)/mypage"
    private var resignationUrl = "\(Constant.BASE_URL)/out"
    private var profileEditUrl = "\(Constant.BASE_URL)/profile"
    
    
    
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
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    //팀코드로 jwt발급
    func requestFetchTeamCode(with teamCode: String, completion: @escaping (TeamCodeResponse?, Error?) -> ()) {
        let url = "\(teamCodeUrl)"

        let teamCodeDic: [String: String]  = [ "code": teamCode]

        AF.request(url, method: .post, parameters: teamCodeDic, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: TeamCodeResponse.self) { (response) in
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
    
    //자동 로그인
    func requestFetchAutoLogin(completion: @escaping (AutoLoginResponse?, Error?) -> ()) {
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
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    //프로필 조회
    func requestFetchMyProfile(completion: @escaping (MyProfileResponse?, Error?) -> ()) {
        let url = "\(myProfileUrl)"

        AF.request(url, method: .get, parameters: nil,encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: MyProfileResponse.self) { (response) in
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
    
    //프로필 수정
    func requestFetchEditProfile(with input: EditProfileInput,completion: @escaping (EditProfileResponse?, Error?) -> ()) {
        let url = "\(profileEditUrl)"

        AF.request(url, method: .patch, parameters: input.toDictionary, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: EditProfileResponse.self) { (response) in
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
    
    
    //퇴사신청
    func requestFetchResignation(completion: @escaping (ResignationRequestResponse?, Error?) -> ()) {
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
                        
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    //FCM 디바이스 토큰 서버로 전달
    func requestFetchFCMDeviceToken(with deviceToken: String, completion: @escaping (FCMDeviceTokenSaveReponse?, Error?) -> ()) {
        let url = "\(deviceTokenSaveUrl)"
        let deviceTokenDictionary: [String: String]  = ["token": deviceToken]

        AF.request(url, method: .post, parameters: deviceTokenDictionary, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: FCMDeviceTokenSaveReponse.self) { (response) in
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
