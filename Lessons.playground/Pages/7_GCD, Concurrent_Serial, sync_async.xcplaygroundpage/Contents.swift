//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import UIKit

// MARK: GCD, Concurrent_Serial, sync_async

class customQueue {
    private let serialQueue = DispatchQueue(label: "serial") // example own serial queue
    private let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent) // example own concurrent queue
}

class systemQueue {
    private let globalQueue = DispatchQueue.global() // example system queue
    private let mainQueue = DispatchQueue.main
}


// MARK: GCD
// First step: Set a thread DispatchQueue.global(), DispatchQueue.main
// Second step:
// Hight priority   DispatchQueue.global(qos: .userInteractive), (qos: .userInitiated), (qos: .utility)
// Low priority     DispatchQueue.global(qos: .background)
// Default          DispatchQueue.global()
// Third Step: .sync/.async

class FirstViewController: UIViewController {
    
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VC 1"
        view.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(press), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initButton()
    }
    
    @objc func press() {
        print("Pressed")
        let vc = SecondViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initButton() {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.setTitle("Push me", for: .normal)
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = 20
        button.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(button)
    }
}

class SecondViewController: UIViewController {
    
    var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VC 2"
        view.backgroundColor = UIColor.white
        
        
        getPhoto()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initImage()
    }
    
    func initImage() {
        image.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        image.center = view.center
        view.addSubview(image)
    }
    
    func getPhoto() {
        let imageURL = URL(string: "https://i.ytimg.com/vi/1Ne1hqOXKKI/maxresdefault.jpg")!
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
            }
        }
    }
}


let vc = FirstViewController()
let navBar = UINavigationController(rootViewController: vc)
navBar.view.frame = CGRect(x: 10, y: 10, width: 300, height: 500)

PlaygroundPage.current.liveView = navBar





//: [Next](@next)
