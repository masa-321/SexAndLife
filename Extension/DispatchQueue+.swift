//
//  DispatchQueue+.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/21.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import Foundation

extension DispatchQueue {
    class func mainSyncSafe(execute work: () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync(execute: work)
        }
    }
    
    class func mainSyncSafe<T>(execute work: () throws -> T) rethrows -> T {
        if Thread.isMainThread {
            return try work()
        } else {
            return try DispatchQueue.main.sync(execute: work)
        }
    }
}
