//
//  CloverDataService.swift
//  MondaySally
//
//  Created by meng on 2021/07/18.
//

import Alamofire

struct CloverDataService {
    
    static let shared = CloverDataService()
    private var cloverHistoryUrl = "\(Constant.BASE_URL)/clover"
    private var cloverRankingUrl = "\(Constant.BASE_URL)/rank"
    
    
    //MARK: 클로버 관련 API
    //클로버 누적 히스토리 API
    func requestFetchCloverAccumulate(completion: @escaping (CloverAccumulateResponse?, Error?) -> ()) {
        let url = "\(cloverHistoryUrl)?type=accumulate&page=1"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: CloverAccumulateResponse.self) { (response) in
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
    
    //클로버 현재 히스토리 API
    func requestFetchCloverCurrent(completion: @escaping (CloverCurrentResponse?, Error?) -> ()) {
        let url = "\(cloverHistoryUrl)?type=current&page=1"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: CloverCurrentResponse.self) { (response) in
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
    
    //클로버 사용 히스토리 API
    func requestFetchCloverUsed(completion: @escaping (CloverUsedResponse?, Error?) -> ()) {
        let url = "\(cloverHistoryUrl)?type=used&page=1"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: CloverUsedResponse.self) { (response) in
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
    
    //클로버 랭킹 조회 API
    func requestFetchCloverRanking(completion: @escaping (CloverRankingResponse?, Error?) -> ()) {
        let url = "\(cloverRankingUrl)"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: CloverRankingResponse.self) { (response) in
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
