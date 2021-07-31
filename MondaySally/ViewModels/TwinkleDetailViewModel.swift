//
//  TwinkleDetailViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/21.
//

class TwinkleDetailViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: TwinkleDataService?
    var twinkleDetailInfo: TwinkleDetailInfo? { didSet { self.didFinishFetch?() } }
    
    //MARK: 프로퍼티 DidSet
    var error: Error? { didSet { self.showAlertClosure?() } }
    var failMessage: String? { didSet { self.showAlertClosure?() } }
    var failCode: Int? { didSet { self.codeAlertClosure?() } }
    var isLoading: Bool = false { didSet { self.updateLoadingStatus?() } }
    
    //MARK: 클로져
    var showAlertClosure: (() -> ())?
    var codeAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: 생성자
    init(dataService: TwinkleDataService) {
        self.dataService = dataService
    }
    
    //MARK: 전체 트윙클 총 갯수
    var numOfTwinkleImage: Int {
        return twinkleDetailInfo?.twinkleImageList.count ?? 0
    }
    
    //MARK: 전체 트윙클 총 갯수
    var numOfComment: Int {
        return twinkleDetailInfo?.commentCount ?? 0
    }
    
    //MARK: 트윙클 인덱스 조회
    var twinkleImageList: [String]? {
        return twinkleDetailInfo?.twinkleImageList
    }
    
    // MARK: 트윙클 상세 API 호출 함수
    func fetchTwinkleDetail(with index: Int){
        self.isLoading = true
        self.dataService?.requestFetchTwinkleDetail(with: index, completion: { [weak self] response, error in
            guard let strongself = self else { return }
            if let error = error {
                strongself.error = error
                strongself.isLoading = false
                return
            }
            if let isSuccess = response?.isSuccess {
                if !isSuccess {
                    strongself.failMessage = response?.message
                    strongself.failCode = response?.code
                    strongself.isLoading = false
                    return
                }
            }
            strongself.error = nil
            strongself.failMessage = nil
            strongself.twinkleDetailInfo = response?.result
            strongself.isLoading = false
            
        })
    }
}
