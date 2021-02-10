//
//  JRNavBaseController.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 12/08/19.


import UIKit

public enum JRNCBarButtonSwift{
    case left
    case right
}

public enum JRNCAxisSwift{
    case horizontal
    case vertical
}

@objc open class JRNavBaseController: UIViewController {

    private var navBarSeparatorImage : UIImage?

    /**
     * Set this to Show/Hide Tab bar
     * Use in viewDidLoad:
     **/
    public var prefersTabBarHidden : Bool = true


    /**
     * Set this to Enable/Disable automatic pop on Left button tap
     * Use in viewDidLoad:
     **/
    public var automaticallyHandleLeftButtonPop : Bool = true

    //MARK: DEFAULT METHODS
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBarForceFully()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBackgroundColor(.white, withAnimation: false)
        self.showSeparator(true)
    }

    //MARK: TAB BAR CONFIGURATION

    /**
     * Hide Tab Bar If It's not the first controller of the navigation controller
     **/
    public func hideTabBarIfNecessary(){
        if let navController = self.navigationController, navController.viewControllers.count == 1{
            self.hideTabBar(hide: false)
        }else{
            self.hideTabBar(hide: true)
        }
    }

    /**
     * Hide Tab Bar on any screen
     **/
    public func hideTabBar(hide : Bool){
        if let tabController = self.tabBarController{
            tabController.tabBar.isHidden = hide
        }
    }

    private func setupTabBar(){
        self.prefersTabBarHidden = true
    }

    //MARK: NAV BAR CONFIGURATION

    /**
     * Configure Navigation bar Forcefully, if it didn't happen in ViewDidLoad:
     */
    public func configureNavBarForceFully(){
        self.automaticallyHandleLeftButtonPop = true
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        self.setupTabBar()
        if let navController = self.navigationController, navController.viewControllers.count > 1{
            self.configureNavBar(withLeftBtnImage: UIImage.init(named: "back_default", in: Bundle.main, compatibleWith: UITraitCollection.init()), withTitle: self.title, andRightBtnImage: nil)
        }
        self.navBarSeparatorImage = nil
    }

    /**
     * Hide Nav bar with no animation
     **/
    open func hideNavBar(_ hide : Bool){
        self.hideNavBar(hide, isAnimated: false)
    }

    /**
     * Hide Nav bar with animation
     **/
    public func hideNavBar(_ hide : Bool,isAnimated animation: Bool){
        if let navController = self.navigationController{
            navController.setNavigationBarHidden(hide, animated: animation)
            if let superView = navController.navigationBar.superview{
                if hide{
                    superView.sendSubviewToBack(navController.navigationBar)
                }else{
                    superView.bringSubviewToFront(navController.navigationBar)
                }
            }
        }
    }

    /**
     * Set Left Button, Right Button and Title for the Nav Bar
     * Do not use this method to set individual items
     **/
    public func configureNavBar(withLeftBtnImage leftBtnImage : UIImage?, withTitle title:String?, andRightBtnImage rightBtnImage: UIImage?){

        //Setup Left Button
        if let leftBtnImage = leftBtnImage{
            let leftItem : UIBarButtonItem = UIBarButtonItem.init(image: leftBtnImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action:  #selector(navigationLeftButtonTapped))
            leftItem.tintColor = .clear
            self.navigationItem.leftBarButtonItem = leftItem
        }else{
            self.navigationItem.leftBarButtonItem = nil
        }

        //Setup Right Button
        if let rightBtnImage = rightBtnImage{
            let rightItem : UIBarButtonItem = UIBarButtonItem.init(image: rightBtnImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(navigationRightButtonTapped))
            self.navigationItem.rightBarButtonItem = rightItem
        }else{
            self.navigationItem.rightBarButtonItem = nil
        }

        //Setup Title
        if let title = title{
            self.title = title
        }else{
            self.title = ""
        }
    }

    /**
     * Set Only Left Item for Nav Bar
     **/
    public func configureLeftItem(withBarButton leftBtn : UIBarButtonItem?, isClickable clickable: Bool){
        if let leftBtn : UIBarButtonItem = leftBtn{
            if clickable{
                leftBtn.target = self
                leftBtn.action = #selector(navigationLeftButtonTapped)
            }
            self.navigationItem.leftBarButtonItem = leftBtn
        }else{
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.setHidesBackButton(true, animated: false)
        }
    }

    /**
     * Set Custom view for left Item
     **/
    public func configureLeftItem(withCustomView leftView : UIView?){
        if let leftView = leftView{
            let leftItem = UIBarButtonItem.init(customView: leftView)
            self.navigationItem.leftBarButtonItem = leftItem
        }else{
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.setHidesBackButton(true, animated: false)
        }
    }

    /**
     * Set Only Right item for Nav Bar
     **/
    public func configureRightItem(withBarButton rightBtn : UIBarButtonItem?, isClickable clickable: Bool){
        if let rightBtn = rightBtn{
            if clickable{
                rightBtn.target = self
                rightBtn.action = #selector(navigationRightButtonTapped)
            }
            self.navigationItem.rightBarButtonItem = rightBtn
        }else{
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    /**
     * Set Custom view for Right Item
     **/
    public func configureRightItem(withCustomView rightView : UIView?){
        if let rightView = rightView{
            let rightItem : UIBarButtonItem = UIBarButtonItem.init(customView: rightView)
            self.navigationItem.rightBarButtonItem = rightItem
        }else{
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    /**
     * Set Image on Nav Bar Title
     **/
    public func configureTitle(withCustomView view : UIView?){
        if let view = view{
           self.navigationItem.titleView = view
        }else{
            self.navigationItem.titleView = nil
        }
    }

    /**
     * Set Text on Nav Bar Title
     **/
    public func configureTitle(withText text: String?){
        if let text = text{
            self.navigationItem.title = text
        }else{
            self.navigationItem.title = ""
        }
    }

    /**
     * Override this to do action on left button
     **/
    @objc open func navigationLeftButtonTapped(){
        if self.automaticallyHandleLeftButtonPop{
            self.navigationController?.popViewController(animated: true)
        }
        // IMPLEMENTATION : NEED TO BE OVERRIDDEN BY SUBCLASSES
    }

    /**
     * Override this to do action on right button
     **/
    @objc open func navigationRightButtonTapped(){
        // IMPLEMENTATION : NEED TO BE OVERRIDDEN BY SUBCLASSES
    }

    /**
     * Set background color of Navigation bar Animated
     **/
    public func setBackgroundColor(_ color : UIColor, withAnimation animated : Bool){
        if animated{
            UIView.animate(withDuration: 0.25, animations: {
                self.navigationController?.navigationBar.barTintColor = color
                self.navigationController?.navigationBar.backgroundColor = color
            }) { (finished) in
                self.navigationController?.navigationBar.barTintColor = color
                self.navigationController?.navigationBar.backgroundColor = color
            }
        }else{
            self.navigationController?.navigationBar.barTintColor = color
            self.navigationController?.navigationBar.backgroundColor = color
        }
    }

    /**
     * Change position of bar button.
     * Parameters :-
     1) barButton of JRNCBarButton type, possible values Left/Right
     2) axis of JRNCAxis type, possible values Horizontal/ Vertical
     3) displacement of int type, can take positive/negative values
     **/
    public func offsetBarButton(_ barButton : JRNCBarButtonSwift, along axis: JRNCAxisSwift, by displacement : Int){
        var edgeInsets = UIEdgeInsets.zero
        switch barButton{
        case .left:
            if let leftBtn = self.navigationItem.leftBarButtonItem{
                edgeInsets = leftBtn.imageInsets
                if axis == .horizontal{
                    edgeInsets.left = edgeInsets.left + CGFloat(displacement)
                }else{
                    edgeInsets.top = edgeInsets.top + CGFloat(displacement)
                }
                leftBtn.imageInsets = edgeInsets
            }
            break
        case .right:
            if let rightBtn = self.navigationItem.rightBarButtonItem{
                edgeInsets = rightBtn.imageInsets
                if axis == .horizontal{
                    edgeInsets.right = edgeInsets.right + CGFloat(displacement)
                }else{
                    edgeInsets.top = edgeInsets.top + CGFloat(displacement)
                }
                rightBtn.imageInsets = edgeInsets
            }
            break
        }
    }

    /**
     * Method to Show/Hide shadow of Navigation Bar.
     * Note :- By default the shadow is visible.
     **/
    public func showSeparator(_ flag : Bool){
        if flag{
            self.navigationController?.navigationBar.shadowImage = nil
        }else{
            if nil == self.navBarSeparatorImage{
                self.navBarSeparatorImage = UIImage()
            }

            self.navigationController?.navigationBar.shadowImage = self.navBarSeparatorImage
        }
    }

    /**
     * Method to enabled/disable translucent for tab bar
     **/
    public func setTabBarTranslucent(isTranslucent : Bool){
        self.tabBarController?.tabBar.isTranslucent = isTranslucent
    }

}
