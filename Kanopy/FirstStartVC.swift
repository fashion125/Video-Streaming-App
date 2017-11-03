//
//  FirstStartVC.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 15/06/2017.
//
//

/// Protocol for home view controller
protocol FirstStartVCDelegate: class {
    
    func didClickSignUp()
    
    func didClickLogIn()
    
    func didClickBrowseAsGuest()
}


class FirstStartVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, ThirdPageVCDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var firstStartVCDelegate: FirstStartVCDelegate?
    var pageViewController: UIPageViewController!
    private(set) lazy var orderedViewControllers: [UIViewController]! = [self.firstPage(), self.secondPage(), self.thirdPage()]
    
    
    init(firstStartVCDelegate: FirstStartVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        self.firstStartVCDelegate = firstStartVCDelegate
    }
    
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        return self.orderedViewControllers[index]
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        self.pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.view.frame = self.view.frame
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        pageViewController.setViewControllers([viewControllerAtIndex(index: 0)!], direction: .forward, animated: true, completion: nil)
        pageViewController.didMove(toParentViewController: self)
        
        pageControl.numberOfPages = orderedViewControllers.count
        
        self.view.bringSubview(toFront: self.pageControl)
    }
    
    func firstPage() -> UIViewController {
        return FirstPageVC.init()
    }
    
    func secondPage() -> UIViewController {
        return SecondPageVC.init()
    }
    
    func thirdPage() -> UIViewController {
        return ThirdPageVC.init(delegate: self)
    }
    
    
    func didClickSignUp() {
        self.firstStartVCDelegate?.didClickSignUp()
    }
    
    
    func didClickLogIn() {
        self.firstStartVCDelegate?.didClickLogIn()
    }
    
    
    func didClickBrowseAsGuest() {
        self.firstStartVCDelegate?.didClickBrowseAsGuest()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = orderedViewControllers.index(of: viewController) {
            if index > 0 {
                return viewControllerAtIndex(index: index - 1)
            }
        }
        
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = orderedViewControllers.index(of: viewController) {
            if index < orderedViewControllers.count - 1 {
                return viewControllerAtIndex(index: index + 1)
            }
        }
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (finished) {
            let vc = pageViewController.viewControllers!.first!
            let index = orderedViewControllers.index(of: vc)!
            pageControl.currentPage = index
        }
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
