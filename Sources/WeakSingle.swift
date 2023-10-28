//
//  WeakSingle.swift
//  VCDependency
//
//  Created by Cherepyanko Valentin on 09/08/2020.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// Weak single dependency.
///
/// Holds a weak reference to the object inside.
/// If the object was freed from memory, rebuilds it.
///
/// Warning!
/// Even though the generic constraint is `Any`, this container is intended for reference types.
/// Be careful with what you put inside.
///
/// Uses `NSLock` for synchronization between the threads.
public final class WeakSingle<T: Any> {

    private let builder: () -> T

    private weak var object: AnyObject?
    private let lock = NSLock()

    public init(builder: @escaping () -> T) {
        self.builder = builder
    }

    public func get() -> T {

        if let alreadyBuilt = object as? T { return alreadyBuilt }

        lock.lock()

        if let alreadyBuilt = object as? T { return alreadyBuilt }
        let object = builder()
        self.object = object as AnyObject

        lock.unlock()

        return object
    }
}
