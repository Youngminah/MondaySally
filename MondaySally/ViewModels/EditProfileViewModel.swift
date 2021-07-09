//
//  ProfileEditViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/09.
//

class EditProfileViewModel {
    private var dataService: DataService?
    // MARK: - Properties
    private var editProfileResponse: EditProfileResponse? {
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
    
    var message: String {
        guard let message = editProfileResponse?.message else {
            print("인터넷 통신은 완료 되었지만, 응답의 message를 upwrapping 할 수 없습니다")
            return ""
        }
        return message
    }
    
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    // MARK: - 생성자
    init(dataService: DataService) {
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
