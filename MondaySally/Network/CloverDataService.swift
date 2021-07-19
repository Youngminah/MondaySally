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
    //클로버 히스토리 API
    func requestFetchCloverHistory(completion: @escaping (CloverHistoryResponse?, Error?) -> ()) {
        let url = "\(cloverHistoryUrl)"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: CloverHistoryResponse.self) { (response) in
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
