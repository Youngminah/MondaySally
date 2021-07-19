//
//  HomeDataService.swift
//  MondaySally
//
//  Created by meng on 2021/07/20.
//

import Alamofire

struct HomeDataService {
    
    static let shared = HomeDataService()
    private var homeUrl = "\(Constant.BASE_URL)/main"
    
    
    //MARK: 홈 탭바 관련 API
    //홈화면 조회 API
    func requestFetchHome(completion: @escaping (HomeResponse?, Error?) -> ()) {
        let url = "\(homeUrl)"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: HomeResponse.self) { (response) in
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
