//
//  FCMDeviceTokenViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/13.
//

class FCMDeviceTokenViewModel {
    private var dataService: DataService?
    // MARK: - Properties
    private var deviceTokenResponse: FCMDeviceTokenSaveReponse? {
        didSet {
            self.didFinishFetch?()
        }
    }
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    
    var failMessage: String? {
        didSet { self.showAlertClosure?() }
    }
    
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    var showAlertClosure: (() -> ())?
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
    init(dataService: DataService) {
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
                    self?.isLoading = false
                    return
                }
            }
            self?.error = nil
            self?.failMessage = nil
            self?.isLoading = false
            self?.deviceTokenResponse = response
            
        })
    }
}
