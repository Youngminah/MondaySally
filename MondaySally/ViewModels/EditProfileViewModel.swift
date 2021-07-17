//
//  ProfileEditViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/09.
//

class EditProfileViewModel {
    
    // MARK: - Properties
    private var dataService: AuthDataService?
    private var editProfileResponse: EditProfileResponse? { didSet { self.didFinishFetch?() } }
    
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
    init(dataService: AuthDataService) {
        self.dataService = dataService
    }
    
    func fetchEditProfile(with input: EditProfileInput){
        self.isLoading = true
        self.dataService?.requestFetchEditProfile(with: input, completion: { [weak self] response, error in
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
            self?.isLoading = false
            self?.editProfileResponse = response
            
        })
    }
}
