//
//  GiftDataService.swift
//  MondaySally
//
//  Created by meng on 2021/07/17.
//

import Alamofire


struct GiftDataService {
    
    static let shared = GiftDataService()
    
    private var giftUrl = "\(Constant.BASE_URL)/gift"
    private var myGiftLogUrl = "\(Constant.BASE_URL)/giftlog"
    
    
    //MARK: 기프트 관련 API
    //기프트 리스트 조회 API
    func requestFetchGiftList(completion: @escaping (GiftListResponse?, Error?) -> ()) {
        let url = "\(giftUrl)?page=1"

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GiftListResponse.self) { (response) in
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
    
    func requestFetchGiftListNext(currentPage: GiftListInfo, completion: @escaping (GiftListResponse?, Error?) -> ()) {
        let url = "\(giftUrl)" //현재페이지의 넥스트.넣기

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GiftListResponse.self) { (response) in
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
    

    
    //기프트 상세 조회 API
    func requestFetchGiftDetail(with giftIndex: Int, completion: @escaping (GiftDetailResponse?, Error?) -> ()) {
        let url = "\(giftUrl)/\(giftIndex)"

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GiftDetailResponse.self) { (response) in
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
    
    //기프트 신청 API
    func requestFetchGift(with input: GiftRequestInput, completion: @escaping (GiftRequestResponse?, Error?) -> ()) {
        let url = "\(giftUrl)"

        AF.request(url, method: .post, parameters: input.toDictionary, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GiftRequestResponse.self) { (response) in
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
    
    
    //내가 신청한 기프트 로그 조회 API
    func requestFetchMyGiftLog(completion: @escaping (GiftHistoryResponse?, Error?) -> ()) {
        let url = "\(myGiftLogUrl)?page=1"

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GiftHistoryResponse.self) { (response) in
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
