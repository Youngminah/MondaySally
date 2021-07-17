//
//  FCMDeviceTokenViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/13.
//

class FCMDeviceTokenViewModel {
    
    // MARK: - Properties
    private var dataService: AuthDataService?
    private var deviceTokenResponse: FCMDeviceTokenSaveResponse? { didSet { self.didFinishFetch?() } }
    
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
    
    var message: String {
        guard let message = deviceTokenResponse?.message else {
            print("인터넷 통신은 완료 되었지만, 응답의 message를 upwrapping 할 수 없습니다")
            return ""
        }
        return message
    }
    
    // MARK: - 생성자
    init(dataService: AuthDataService) {
        self.dataService = dataService
    }
    
    func fetchFCMDeivceToken(with deviceToken: String){
        self.isLoading = true
        self.dataService?.requestFetchFCMDeviceToken(with: deviceToken, completion: { [weak self] response, error in
            if let error = error {
                self?.error = error
                self?.isLoading = false
                return
            }
            if let isSuccess = response?.isSuccess {
                if !isSuccess {
                    self?.failMessage = response?.message
                    self?.failCode = response?.code
                    self?.isLoading = false
                    return
                }
            }
            self?.error = nil
            self?.failMessage = nil
            self?.deviceTokenResponse = response
            self?.isLoading = false
            
        })
    }
}
