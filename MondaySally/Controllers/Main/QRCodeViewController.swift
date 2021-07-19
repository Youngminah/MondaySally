//
//  QRCodeViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit
import AVFoundation



class QRCodeViewController: UIViewController {
    
    var captureSession = AVCaptureSession() //비디오에서 들어온 데이터 인풋을 아웃풋으로 조정하는데 쓰이는 객체
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private let viewModel = CommuteViewModel(dataService: AuthDataService())
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var qrCodeFrameView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.createQRCaptureModule()
    }
}


extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // 메타데이터오브젝트 배열에 뭐가 있는지 확인
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        //메타데이터 얻기
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            //메타데이터가 큐알이라면 현재 상태 레이블에 표시해주기
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                guard let data = metadataObj.stringValue else { return }
                print("성공입니다 !! 숨겨진 메세지는?-> \(data)")
                self.dismissAnimation()
                self.attemptFetchCommute()
                captureSession.stopRunning()
            }
        }
    }
    
    private func createQRCaptureModule(){
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("후반 카메라를 가져오는 것에 실패함.")
            return
        }
        
        do {
            //Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            //Set the input device on the capture session
            captureSession.addInput(input) //메타데이터 아웃풋을 내놓는다. 큐알 코드 읽기의 핵심!!
            
            //AVCaptureMetadataOutput 객체 초기화 & 캡쳐 세션에 설정.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to excute the call back
            // 새로운 메타 데이터가 캡쳐되면 처리를 위해 델리게이트 객체에 전달된다.
            // 델리게이트 메서드를 실행할 디스패치 큐를 설정하는 것. (애플문서에 따르면 디스패치큐는 직렬이여야한다.)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes // 타입도 중요함. qr을 원하는 것을 명시한다.
            
            //비디오 미리보기 레이어를 설정해주고 서브레이어를 추가한다.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = qrCodeFrameView.layer.bounds
            qrCodeFrameView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
            //Move the message label and top bar to the front
            
            //큐알코드가 인식되었을 때에 프레임 틀에 하이라이트 주기 , 이걸 설정하기 전에는 자동으로 0이 들어가있어서 눈에 안보였었음.
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.cornerRadius = 4
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
                view.bringSubviewToFront(qrImageView)
                self.showAnimation()
            }
            
        } catch {
            if error.localizedDescription == "Cannot use Back Camera" {
                self.showSallyNotationAlert(with: "설정에서 카메라 사용을\n허용해주세요.") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            return
        }
    }
    
    private func showAnimation(){
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            guard let self = self else { return }
            self.qrImageView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1.1, y: 1.1)
        })
    }
    
    private func dismissAnimation(){
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.qrImageView.transform = CGAffineTransform.identity
        })
    }
}


// MARK: QR 출퇴근 신청 API
extension QRCodeViewController {
    
    private func attemptFetchCommute() {
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }

        self.viewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.viewModel.error {
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.viewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        
        self.viewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {

            }
        }

        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("출퇴근 신청에 성공했습니다 !! ")
                strongSelf.showSallyNotationAlert(with: "성공적으로\n출근 되었습니다.") {
                    strongSelf.navigationController?.popViewController(animated: true)
                }

            }
        }
        self.viewModel.fetchCommute()
    }
    
}
