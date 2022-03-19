# MainTabView

[![CI Status](https://img.shields.io/travis/mozead1996/MainTabView.svg?style=flat)](https://travis-ci.org/mozead1996/MainTabView)
[![Version](https://img.shields.io/cocoapods/v/MainTabView.svg?style=flat)](https://cocoapods.org/pods/MainTabView)
[![License](https://img.shields.io/cocoapods/l/MainTabView.svg?style=flat)](https://cocoapods.org/pods/MainTabView)
[![Platform](https://img.shields.io/cocoapods/p/MainTabView.svg?style=flat)](https://cocoapods.org/pods/MainTabView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MainTabView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MainTabView'
```

## Usage 

### Usage : 
1. in the hosting controller add UIView and set its class to MainTabView
1. drag outlet of MainTabView 
1. import MainTabView
1. set dataSource to self 

### code snipts :

```swift

import ZMainTabView


    @IBOutlet weak var mainTabView: MainTabView?

 class ViewController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainTabView?.dataSource = self
    }
}

//here we give it our viewControllers to show 

extension ViewController : MainTabViewDataSource{

// each child UIViewController should conform to TabItem
    
    func viewControllersToBeHosted(in MainTabView: MainTabView) -> [TabItem] {
        let firstVC = instance(FirstViewController.self)//FirstViewController.instance()
        let secondVC = instance(SecondViewController.self)
        let thirdVC = instance(ThirdViewController.self)
        
        return [firstVC,secondVC,thirdVC]
    }
 }
 
```
## Author

mozead1996, mohamedzead2021@gmail.com

## License

MainTabView is available under the MIT license. See the LICENSE file for more info.
