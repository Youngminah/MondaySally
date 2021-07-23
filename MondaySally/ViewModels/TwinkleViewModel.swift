//
//  TwinkleViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/19.
//
import Foundation
import UIKit

class TwinkleViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: TwinkleDataService?
    private var twinkleInfo = [TwinkleInfo]()
    
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
    
    var pageIndex = 1
    var endOfPage = false
    var isPagination = false
    
    // MARK: 생성자
    init(dataService: TwinkleDataService) {
        self.dataService = dataService
    }
    
    //MARK: 전체 트윙클 총 갯수
    var numOfTwinkle: Int {
        return twinkleInfo.count
    }
    
    var remainderOfTwinklePagination: Int {
        if twinkleInfo.count == 0{
            return 0
        }
        return twinkleInfo.count % 20
    }
    

    func setLike(at index: Int, status: String) {
        let count = self.twinkleInfo[index].likeCount
        self.twinkleInfo[index].isHearted  = status
        if status == "Y" {
            self.twinkleInfo[index].likeCount  = count + 1
        }else {
            self.twinkleInfo[index].likeCount  = count - 1
        }
    }
    
    //MARK: 트윙클 인덱스 조회
    func twinkleList(at index: Int) -> TwinkleInfo? {
        return twinkleInfo[index]
    }
    
    // MARK: 전체 트윙클 페이징 적용 API 호출 함수
    func fetchTwinkleTotal(with pagination : Bool = false){
        if endOfPage{ return }
        if pagination {
            self.isPagination = true
            self.pageIndex = self.pageIndex + 1
        } else {
            self.isLoading = true
        }
        self.dataService?.requestFetchTwinkleTotal(page: self.pageIndex,completion: { [weak self] response, error in
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
                    if strongself.failCode == 366 { strongself.endOfPage = true }
                    strongself.didEndPagination(with: pagination)
                    return
                }
            }
            strongself.error = nil
            strongself.failMessage = nil
            if strongself.isPagination{
                strongself.twinkleInfo.append(contentsOf: response?.result?.twinkles ?? [])
            }else {
                strongself.twinkleInfo = response?.result?.twinkles ?? []
            }
            strongself.didFinishFetch?()
            strongself.didEndPagination(with: pagination)
        })
    }
    
    
    private func didEndPagination(with pagination: Bool){
        pagination ? (self.isPagination = false) : (self.isLoading = false)
    }
}
