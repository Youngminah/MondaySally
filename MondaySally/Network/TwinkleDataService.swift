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
    private var proveUrl = "\(Constant.BASE_URL)/prove"
    private var likeUrl = "\(Constant.BASE_URL)/like"
    private var commentUrl = "\(Constant.BASE_URL)/comment"
    
    
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
    
    //증빙/미증빙 트윙클 목록 조회 API
    func requestFetchTwinkleProve(completion: @escaping (TwinkleProveResponse?, Error?) -> ()) {
        let url = "\(proveUrl)?page=1"
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
    
    //트윙클 삭제 API
    func requestFetchTwinkleDelete(with index: Int, completion: @escaping (NoDataResponse?, Error?) -> ()) {
        let url = "\(twinkleUrl)/out/\(index)"
        AF.request(url, method: .patch, parameters: nil, encoding: JSONEncoding.default, headers: Constant.HEADERS)
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
    
    //트윙클 좋아요/취소 API
    func requestFetchTwinkleLike(with index: Int, completion: @escaping (NoDataResponse?, Error?) -> ()) {
        let url = "\(likeUrl)/\(index)"
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: Constant.HEADERS)
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
    
    //트윙클 댓글 작성 API
    func requestFetchTwinkleCommentWrite(with index: Int, with content: String, completion: @escaping (NoDataResponse?, Error?) -> ()) {
        let url = "\(commentUrl)/\(index)"
        let contentToDictionary: [String: String]  = ["content": content]
        AF.request(url, method: .post, parameters: contentToDictionary, encoding: JSONEncoding.default, headers: Constant.HEADERS)
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
    
    //트윙클 댓글 삭제 API
    func requestFetchTwinkleCommentDelete(with index: Int, completion: @escaping (NoDataResponse?, Error?) -> ()) {
        let url = "\(commentUrl)/out/\(index)"
        AF.request(url, method: .patch, parameters: nil, encoding: JSONEncoding.default, headers: Constant.HEADERS)
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
