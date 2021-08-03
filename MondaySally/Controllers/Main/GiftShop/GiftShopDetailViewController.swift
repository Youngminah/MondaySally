//
//  GiftShopDetailViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import TTGTagCollectionView
import UIKit

class GiftShopDetailViewController: UIViewController {
    
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftContentLabel: UILabel!
    @IBOutlet weak var giftRuleLabel: UILabel!
    @IBOutlet weak var optionTitleLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var tagContentView: UIView!
    
    private let collectionView = TTGTextTagCollectionView()
    private var selectOpionIndex = 0
    
    private var input: GiftRequestInput?
    private let giftDetailViewModel = GiftDetailViewModel(dataService: GiftDataService())
    private let giftRequestViewModel = GiftRequestViewModel(dataService: GiftDataService())
    var giftIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attemptFetchGiftDetail(with: giftIndex)
        self.updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tagContentView.addSubview(self.collectionView)
        self.collectionView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.tagContentView.frame.width,
                                           height: self.tagContentView.frame.height)
        //print("x: \(optionTitleLabel.left) y:\(optionTitleLabel.bottom + 20) width: \(view.frame.size.width - 32) height: \(applyButton.top - optionTitleLabel.bottom)")
        //self.collectionView.center = self.tagContentView.center
    }
    
    @IBAction func giftApplyButton(_ sender: UIButton) {
        self.showSallyQuestionAlert(with: "해당 기프트 신청을\n하시겠습니까?") {[weak self] () in
            guard let strongSelf = self else { return }
            guard let clover = strongSelf.giftDetailViewModel.getOptionClover(at: strongSelf.selectOpionIndex) else { return }
            print(strongSelf.giftIndex)
            strongSelf.input = GiftRequestInput(giftIdx: strongSelf.giftIndex, usedClover: clover)
            guard let input = strongSelf.input else { return }
            strongSelf.attemptFetchGiftRequest(with :input)
        }
    }
    
    private func updateUI(){
        self.title = "기프트 샵"
        self.collectionView.alignment = .left
        self.collectionView.delegate = self
        self.collectionView.selectionLimit = 2
        self.parentView.addSubview(collectionView)
    }
    
}

extension GiftShopDetailViewController: TTGTextTagCollectionViewDelegate{
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        if self.selectOpionIndex == index {
            textTagCollectionView.getTagAt(UInt(self.selectOpionIndex)).selected = true
            textTagCollectionView.reload()
        } else {
            textTagCollectionView.getTagAt(UInt(self.selectOpionIndex)).selected = false
            textTagCollectionView.reload()
            self.selectOpionIndex = Int(index)
        }
    }
    
    private func setTag(){
        guard let optionTagList = self.giftDetailViewModel.optionTagList else {
            print("ERROR: 옵션 태그로 변환 실패하다!!")
            return
        }
        self.collectionView.add(optionTagList)
        self.collectionView.getTagAt(UInt(selectOpionIndex)).selected = true
        self.collectionView.reload()
    }
}


// MARK: 기프트 리스트 조회 API
extension GiftShopDetailViewController {

    private func attemptFetchGiftDetail(with index:Int) {
        self.giftDetailViewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.giftDetailViewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }
        self.giftDetailViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.giftDetailViewModel.error {
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.giftDetailViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                    strongSelf.dismiss(animated: true)
                }
            }
        }
        self.giftDetailViewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //JWT 관련 문제로 오류
                if strongSelf.giftDetailViewModel.failCode != 404 {
                    strongSelf.showSallyNotationAlert(with: "로그인 정보를 찾을 수 없어\n로그아웃 합니다.") {
                        DispatchQueue.main.async {
                            strongSelf.removeAllUserInfos()
                            strongSelf.changeRootViewToIntro()
                        }
                    }
                }
                // 서버 문제로 오류
                else {
                    strongSelf.networkFailToExit()
                }
            }
        }

        self.giftDetailViewModel.didFinishFetch = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                print("기프트 상세 조회에 성공했습니다 !! ")
                strongSelf.updateGiftDetailUI()
                strongSelf.updateAfterUI()
            }
        }
        self.giftDetailViewModel.fetchGiftDetail(with: index)
    }
    
    private func updateGiftDetailUI(){
        guard let data = self.giftDetailViewModel.getGiftInfo else {
            print("디테일 기프트 정보를 뜯지 못했습니다.")
            return
        }
        self.giftNameLabel.text = data.name
        self.giftContentLabel.text = data.info
        self.giftRuleLabel.text = data.rule
        self.setGiftThumbnailImage(with :data.thumnail)
    }
    
    private func setGiftThumbnailImage(with url: String){
        self.giftImageView.showViewIndicator()
        let urlString = URL(string: url)
        self.giftImageView.kf.setImage(with: urlString){ result in
            switch result {
            case .success(_):
                self.giftImageView.dismissViewndicator()
            case .failure(let error):
                print(error)
                self.giftImageView.dismissViewndicator()
            }
        }
    }
    
    private func updateAfterUI() {
        if self.giftDetailViewModel.numOfGiftOption == 0 {
            print("옵션 없음!!")
            self.applyButton.isEnabled = false
            self.applyButton.setTitle("준비중입니다.", for: .normal)
            self.applyButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
            noDataLabel.text = "해당 기프트의 옵션은 준비중입니다."
            noDataLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
            noDataLabel.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.parentView.addSubview(noDataLabel)
            noDataLabel.center = self.collectionView.center
            return
        }
        self.setTag()
    }
}


// MARK: 기프트 신청 API
extension GiftShopDetailViewController {
    
    private func attemptFetchGiftRequest(with input: GiftRequestInput) {
        self.giftRequestViewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.giftRequestViewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }
        self.giftRequestViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.giftRequestViewModel.error {
                    print("서버에서 통신 원활하지 않음 ->  +\(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.giftRequestViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        self.giftRequestViewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //Code 353 - 클로버 부족
                if strongSelf.giftRequestViewModel.failCode == 353 {
                    strongSelf.showSallyNotationAlert(with: "클로버가 부족합니다.", complition: nil)
                }
            }
        }
        self.giftRequestViewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("기프트 신청에 성공했습니다 !! ")
                strongSelf.moveToCompletedView()
            }
        }
        self.giftRequestViewModel.fetchGiftRequest(with: input)
    }
    
    private func moveToCompletedView(){
        guard let data = self.giftRequestViewModel.giftInfo else { return }
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GiftCompletedView") as? GiftCompletedViewController else{
            return
        }
        vc.giftInfo = GiftWriteInfo(idx: data.idx , name: data.name, clover: data.clover)
        self.navigationItem.backButtonTitle = " "
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


