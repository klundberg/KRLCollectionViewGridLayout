// Playground - noun: a place where people can play

import UIKit

class test {
    var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
    didSet {
        if insets != oldValue {
            println("changed!")
        }
    }
    }
}