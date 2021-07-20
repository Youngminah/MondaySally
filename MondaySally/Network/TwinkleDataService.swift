//
//  TwinkleDataService.swift
//  MondaySally
//
//  Created by meng on 2021/07/19.
//
import Alamofire

struct TwinkleDataService {
    
    static let shared = TwinkleDataService()
    
    private var twinkleUrl = "\(Constant.BASE_URL)/twinkle"
    private var twinkleProveUrl = "\(Constant.BASE_URL)/prove"
    private var twinkleLikeUrl = "\(Constant.BASE_URL)/like"
    
    
    //MARK: 트윙클 관련 API
    //트윙클 히스토리 API
    func requestFetchTwinkleTotal(completion: @escaping (TwinkleResponse?, Error?) -> ()) {
        let url = "\(twinkleUrl)?page=1"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: TwinkleResponse.self) { (response) in
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
    
    
    //트윙클 상세 API
    func requestFetchTwinkleDetail(with index: Int, completion: @escaping (TwinkleDetailResponse?, Error?) -> ()) {
        let url = "\(twinkleUrl)/\(index)"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: TwinkleDetailResponse.self) { (response) in
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
    
    //내 트윙클 목록 조회 API
    func requestFetchTwinkleProve(completion: @escaping (TwinkleProveResponse?, Error?) -> ()) {
        let url = "\(twinkleProveUrl)"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: TwinkleProveResponse.self) { (response) in
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
    
    //트윙클 등록 API
    func requestFetchTwinkleWrite(with input: TwinkleWriteInput, completion: @escaping (NoDataResponse?, Error?) -> ()) {
        let url = "\(twinkleUrl)"
        AF.request(url, method: .post, parameters: input.toDictionary, encoding: JSONEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: NoDataResponse.self) { (response) in
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
    
    //트윙클 좋아요 API
    func requestFetchTwinkleLike(with index: Int, completion: @escaping (NoDataResponse?, Error?) -> ()) {
        let url = "\(twinkleLikeUrl)/\(index)"
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: NoDataResponse.self) { (response) in
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
