//
//  ViewController.swift
//  lesson1
//
//  Created by 杨少锋 on 16/11/4.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

import UIKit
class Person: NSObject {
    var name: String?
    var age: Int?
    
    // block 可能的循环引用
    var block: ((Void)->Void)? = nil
    override init() {
        super.init()
        // weak 只能修改变量 ，其值在运行期间会被修改
        // 闭包造成的循环引用([unowned self, weak delegate = self.delegate] 无主引用解决这个问题)
        // 遇见代理的时候我们还需要weak来修饰。注意内存泄漏
       weak var weakself = self;
        self.block = { [unowned self] in
            weakself?.name = "修改";
        }
        self.block!()
    }
    
    deinit {
        // 动态绑定， 因为第51行(p3)创建出来的对象没有name, self.name强制拆包会崩溃
        if let name = self.name {
            print(name + "被解放了");
        }
        
    }
}


class ViewController: UIViewController {
    
    
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // 引用计数
        var p = Person()   // 0 －> 1
        p.name = "小王"
        var p1 = p   // 1 -> 2
        var p2 = p   // 2 -> 3
        
        // 因为类型不匹配，无法赋值nil. 只能修改指针的指向让p释放
        let p3 = Person()
        p1 = p3  // 3 -> 2
        p2 = p3   // 2 -> 1
        p = p3
        
    }

    
    // 两个类相互引用
    // var stu = student()
    // var tea = teachet()
    // tea.student = stu
    // student.tea = tea
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
     对于闭包内的引用，何时使用弱引用，何时使用无主引用呢？
     如果在一个值的生命周期中可能没有值，我们就使用weak，weak可选 ,weak必须被申明为变量，在运行时可能被修改
     如果一只值在生命周期一只有值，我们使用无主引用 , 无主是非可选类型 ，非可选类型不能赋值为nil
     
     */
}

