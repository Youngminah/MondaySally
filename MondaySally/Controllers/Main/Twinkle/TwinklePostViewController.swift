//
//  TwinklePostViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/06.
//

import UIKit

class TwinklePostViewController: UIViewController {

    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let ex:[String] = ["그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요!", "그동안 고생했", "그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! ", "그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! " ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTextView.text = "그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~!"
        self.postTextView.textContainer.lineFragmentPadding = 0;
        self.postTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.title = "미누스님의 트윙클"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
}


extension TwinklePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TwinklePostCommentCell", for: indexPath) as? TwinklePostCommentCell else {
            return UITableViewCell()
        }
        cell.commentTextView.text = ex[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // also UITableViewAutomaticDimension can be used
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        //let size = cell.commentTextView..height
//        if indexPath.row == 1 {
//            return 40
//        } else {
//            return 100
//        }
//    }
    
}
