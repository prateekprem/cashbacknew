//
//  JRLSignUpPrompt.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 02/07/19.
//

import Foundation
import jarvis_utility_ios

class JRLParser: NSObject {
    class func parseResponse(data: Data) -> JRLSignUpResponse?{
        do {
            let jsonDecoder = JSONDecoder()
            let response = try jsonDecoder.decode(JRLSignUpResponse.self, from: data)
            return response
        }
        catch _ {
            return nil
        }
    }
}

class JRLSignUpResponse: Decodable {
    var page: [JRLPageItem]?
}

class JRLPageItem: Decodable {
    var views: [JRLViewItem]?
}

class JRLViewItem: Decodable {
    var items: [JRLPageViewItem]?
}

class JRLPageViewItem:Decodable{
    var image_url : String?
    var url_type : String?
    var url : String?
    var seourl : String?
}

//JRLSingleBannerCVC = JRLSingleBannerCollectionViewCell
class JRLSingleBannerCVC:UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    
    var item :JRLPageViewItem? {
        didSet {
            self.configureData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.configureView()
    }
    
    func configureData() {
        if let item = item, let imgURL: String = item.image_url {
            if let updatedUrl = LoginAuth.sharedInstance().delegate?.getUpdatedStorefrontURL(forUrl: URL(string:imgURL), frame: self.imageView.frame, andImageView :self.imageView){
                self.imageView.jr_setImage(with: updatedUrl, completed: nil)
            }
        }
    }
}

class JRLSignUpPrompt: JRAuthBaseVC, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var doItLaterBtn: UIButton!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    var bannerList : [JRLPageViewItem]? = [JRLPageViewItem]()
    
    // MARK: - View life cycle
    static func controller() -> JRLSignUpPrompt?{
        return UIStoryboard(name:"JRLFPopUp", bundle:JRLBundle).instantiateViewController(withIdentifier: "JRLSignUpPrompt") as? JRLSignUpPrompt
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        JRLoginGACall.signupPopupLoaded()
        var url = "https://storefront.paytm.com/v2/h/app-pop-up"
        if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("signUpStoreFrontUrl") {
            url = baseURL
        }
        LoginAuth.sharedInstance().delegate?.getSignUpBanners(forUrl: url, completionHandler: {(list, isSuccess, error) in
            if let success = isSuccess, success{
                guard let responseDict = list else {
                    return
                }
                guard let jsonData = try? JSONSerialization.data(withJSONObject: responseDict) else{
                    return
                }
                if let parsedResponse : JRLSignUpResponse = JRLParser.parseResponse(data: jsonData) {
                    if let page = parsedResponse.page{
                        for aPage in page{
                            if let view = aPage.views{
                                for aView in view{
                                    if let item = aView.items{
                                        for aItem in item{
                                            self.bannerList?.append(aItem)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                }
            }
        })
        
        let pageWidth: CGFloat = collectionView.frame.size.width
        let currentPage: CGFloat = collectionView.contentOffset.x / pageWidth
        
        if (0.0 != fmodf(Float(currentPage), 1.0)) {
            pageControl.currentPage = Int(currentPage) + 1
        } else {
            pageControl.currentPage = Int(currentPage)
        }
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    @IBAction func onCreateAccBtnTouched(_ sender: UIButton) {
//        JRLoginGACall.signupPopupCreateAccountClicked()
        dismiss(animated: true) {
            let createAccount = JRAuthSignInVC.newInstance
            createAccount.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(createAccount, animated: true)
        }
    }
    
    @IBAction func onDoItLaterBtnTouched(_ sender: UIButton) {
//        JRLoginGACall.signupDoItLaterClicked()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDiscardBtnTouched(_ sender: UIButton) {
//        JRLoginGACall.signupPopupDiscarded()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private helpers
    
    // MARK: - Collection view delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let list = bannerList, list.count > 0{
            pageControl.isHidden = false
            pageControl.numberOfPages = (list.count + 1)
            return (list.count + 1)
        }
        pageControl.isHidden = true
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: JRLSingleBannerCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "JRLSingleBannerCVC", for: indexPath) as! JRLSingleBannerCVC
        if indexPath.row == 0{
            cell.imageView.image = UIImage(named: "signUpBanner", in: JRLBundle, compatibleWith: nil)
        }else{
            if let list = bannerList{
                cell.item = list[indexPath.row-1]
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _: JRLSingleBannerCVC = collectionView.cellForItem(at: indexPath) as? JRLSingleBannerCVC {
            if indexPath.row > 0, let list = bannerList{
                let item = list[indexPath.row-1]
                if let deeplink = item.url{
                    LoginAuth.sharedInstance().delegate?.openDeeplinkUrl(url: URL(string:deeplink), awaitProcessing: true)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let dimension: CGFloat = collectionView.frame.size.width
        return CGSize(width: dimension, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = collectionView.frame.size.width
        let currentPage: CGFloat = collectionView.contentOffset.x / pageWidth
        
        if (0.0 != fmodf(Float(currentPage), 1.0)) {
            pageControl.currentPage = Int(currentPage) + 1
        } else {
            pageControl.currentPage = Int(currentPage)
        }
    }
}
