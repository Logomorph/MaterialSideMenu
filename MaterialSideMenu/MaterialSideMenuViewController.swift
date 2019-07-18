//
//  SlideMenuViewController.swift
//  coresuite-ipad
//
//  Created by Logomorphon 05/04/2017.
//  Copyright © 2017 Logomorph. All rights reserved.
//

import UIKit

public protocol MaterialSideMenuNeedsGestures {
    var needsGestures:Bool { get }
}

@objc public class MaterialSideMenuViewController: UIViewController, UINavigationControllerDelegate {

    /// The view controller used at the bottom of the navigation stack
    public var homeViewController: UIViewController
    /// The view controller displayed in the side menu
    public var mainMenuViewController: UIViewController
    /// Defines a percentage of the screen the menu should fill. Leave nil if it shouldn't be taken into consideration
    public var menuWidthPercentage:CGFloat?
    /// Defines a static width for the menu. Leave nil if it shouldn't be taken into consideration
    public var menuWidthConstant:CGFloat? = 240

    private let leftScreenRecognizer = UIScreenEdgePanGestureRecognizer()
    private let panScreenRecognizer = UIPanGestureRecognizer()
    private var mainMenuHorisontalConstraint: NSLayoutConstraint?
    private var navController: UINavigationController?

    private lazy var overlayView: UIView = {
        UIView()
    }()
    
    public init(homeViewController:UIViewController, mainMenuViewController:UIViewController) {
        self.homeViewController = homeViewController
        self.mainMenuViewController = mainMenuViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupMainMenuConstraints()
        setupGestures()
        mainMenuViewController.didMove(toParent: self)
    }

    fileprivate func setupViews() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.addMenuButtonToViewController(viewController: homeViewController)
        
        navController = UINavigationController(navigationBarClass: UINavigationBar.self, toolbarClass: nil)
        navController?.viewControllers = [homeViewController]
        if let navigationController = navController, let navView = navigationController.view {
            self.view.addSubview(navView)
            self.addChild(navigationController)
        }
        navController?.delegate = self

        overlayView.frame = self.view.bounds
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let dismissButton = UIButton(frame: overlayView.frame)
        dismissButton.addTarget(self, action: #selector(hideMenu), for: UIControl.Event.touchUpInside)
        overlayView.addSubview(dismissButton)
        self.view.addSubview(overlayView)
        self.addChild(mainMenuViewController)
        let alwaysOnTopOfTheViewStack = Int.max
        self.view.insertSubview(mainMenuViewController.view, at: alwaysOnTopOfTheViewStack)
    }

    fileprivate func setupMainMenuConstraints() {
        guard let menuView = mainMenuViewController.view else {
            fatalError("Main menu has no view")
        }
        let views: [String: UIView] = ["menuView": menuView, "parentView": view]
        mainMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(<=0)-[menuView]",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[menuView]|",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))

        let mainMenuHorisontalConstraint = NSLayoutConstraint(item: menuView, attribute: .left, relatedBy: .lessThanOrEqual, toItem: self.view, attribute: .left, multiplier: 1, constant: -view.frame.width)
        mainMenuHorisontalConstraint.priority = UILayoutPriority(rawValue: 1000)
        view.addConstraint(mainMenuHorisontalConstraint)
        
        if let percentage = self.menuWidthPercentage {
            let widthConstraint = NSLayoutConstraint(item: menuView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: percentage, constant: 0.0)
            widthConstraint.priority = UILayoutPriority(rawValue: 999)
            view.addConstraint(widthConstraint)
        } else if let constant = self.menuWidthConstant {
            let widthConstraint = NSLayoutConstraint(item: menuView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
            widthConstraint.priority = UILayoutPriority(rawValue: 999)
            view.addConstraint(widthConstraint)
        }
        
        self.mainMenuHorisontalConstraint = mainMenuHorisontalConstraint
    }

    /// Pushes a view controller onto the stack, dismissing all but the home controller
    @objc public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        hideMenu()
        var viewControllers: [UIViewController] = navController?.viewControllers ?? []
        if viewControllers.count > 1 {
            viewControllers = [viewControllers[0]]
        }

        self.addMenuButtonToViewController(viewController: viewController)

        addFadeAnimation()
        viewControllers.append(viewController)
        navController?.setViewControllers(viewControllers, animated: animated)
    }

    /// Dismiss all controllers and display the home controller
    @objc public func goHome(animated: Bool) {
        addFadeAnimation()
        navController?.popToRootViewController(animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        hideMenu()
    }

    /// Dismiss all controllers and display the home controller
    @objc public func goHome() {
        goHome(animated: false)
    }

    func addFadeAnimation() {
        let fadeTransition = CATransition()
        fadeTransition.type = CATransitionType.fade
        fadeTransition.duration = 0.2
        fadeTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        navController?.view.layer.add(fadeTransition, forKey: nil)
    }

    /// Adds the button to show the side menu to a view controller
    @objc public func addMenuButtonToViewController(viewController: UIViewController) {
        let showMenuButton = MaterialSideMenuViewController.menuButton()
        showMenuButton.target = self
        showMenuButton.action = #selector(self.showMenu)
        var leftBarButtons = [UIBarButtonItem]()
        leftBarButtons.append(showMenuButton)
        
        viewController.navigationItem.leftBarButtonItem = showMenuButton
    }

    static func menuButton() -> UIBarButtonItem {
        let menuButton = UIBarButtonItem(title: "menu", style: .plain, target: nil, action: nil)
        menuButton.accessibilityLabel = "menu_button"
        return menuButton
    }

    override public var shouldAutorotate: Bool {
        return false
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension MaterialSideMenuViewController {
    public func navigationController(_: UINavigationController, didShow: UIViewController, animated: Bool) {
        guard let navigationController = navController else {
            return
        }
        if navigationController.viewControllers.count > 2 {
            disableMenuGestures()
        } else if navigationController.viewControllers.count == 2 {
            let viewController = navigationController.viewControllers[1]
            if (viewControllerNeedsGestures(viewController)) {
                enableMenuGestures(true)
            } else {
                disableMenuGestures()
            }
        } else {
            enableMenuGestures(true)
        }
    }
}

extension MaterialSideMenuViewController {
    fileprivate func setupGestures() {
        leftScreenRecognizer.addTarget(self, action: #selector(self.handlePanGestureRecognizer(_:)))
        leftScreenRecognizer.edges = .left
        leftScreenRecognizer.cancelsTouchesInView = true
        self.view.addGestureRecognizer(leftScreenRecognizer)

        panScreenRecognizer.addTarget(self, action: #selector(self.handlePanGestureRecognizer(_:)))
        panScreenRecognizer.cancelsTouchesInView = true
        self.view.addGestureRecognizer(panScreenRecognizer)
        enableMenuGestures(true)
    }

    @objc fileprivate func handlePanGestureRecognizer(_ pan: UIScreenEdgePanGestureRecognizer) {
        guard let panView = pan.view, let hConstraint = mainMenuHorisontalConstraint else {
            return
        }
        let presenting: Bool = pan.isKind(of: UIScreenEdgePanGestureRecognizer.self)
        let translation = pan.translation(in: panView)

        var velocity = pan.velocity(in: panView).x
        let realProgress = 1.0 - (-hConstraint.constant) / mainMenuViewController.view.frame.width
        let progress = min(realProgress, 0.7)
        self.overlayView.alpha = progress

        if pan.state == .ended {
            if velocity > 0 {
                let duration = hConstraint.constant / velocity
                animateChangeMainMenuLeftMargin(0, duration: TimeInterval(duration))
                enableMenuGestures(false)
            } else {
                if velocity > -0.3 {
                    velocity = -1
                }
                let duration = (mainMenuViewController.view.frame.width - hConstraint.constant) / velocity
                animateChangeMainMenuLeftMargin(-(mainMenuViewController.view.frame.width), duration: TimeInterval(duration))
                enableMenuGestures(true)
            }
        } else {
            if presenting {
                hConstraint.constant = -mainMenuViewController.view.frame.size.width + translation.x
            } else {
                hConstraint.constant = translation.x
            }
        }
    }

    @objc func enableMenuGestures(_ forPresenting: Bool) {
        if forPresenting {
            self.leftScreenRecognizer.isEnabled = true
            self.panScreenRecognizer.isEnabled = false
        } else {
            self.leftScreenRecognizer.isEnabled = false
            self.panScreenRecognizer.isEnabled = true
        }
    }

    @objc func showMenu() {
        animateChangeMainMenuLeftMargin(0)
        enableMenuGestures(false)
    }

    @objc func hideMenu() {
        animateChangeMainMenuLeftMargin(-(mainMenuViewController.view.frame.width))
        enableMenuGestures(true)
    }

    func disableMenuGestures() {
        self.leftScreenRecognizer.isEnabled = false
        self.panScreenRecognizer.isEnabled = false
    }

    fileprivate func animateChangeMainMenuLeftMargin(_ leftMarginValue: CGFloat) {
        animateChangeMainMenuLeftMargin(leftMarginValue, duration: 0.4)
    }

    fileprivate func animateChangeMainMenuLeftMargin(_ leftMarginValue: CGFloat, duration: TimeInterval) {
        mainMenuHorisontalConstraint?.constant = leftMarginValue
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.view.layoutIfNeeded()
            if (leftMarginValue == 0) {
                self.overlayView.alpha = 0.7
            } else {
                self.overlayView.alpha = 0
            }
        }, completion: nil)
    }

    fileprivate func viewControllerNeedsGestures(_ viewController: UIViewController) -> Bool {
        if let needsGestures = viewController as? MaterialSideMenuNeedsGestures {
            return needsGestures.needsGestures
        }
        return true
    }
}
