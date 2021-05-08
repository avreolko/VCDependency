//
//  Single.swift
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

/// Single dependency.
///
/// Holds a strong reference to the object inside.
/// If the object has already been assembled once, always returns it.
/// Designed for common dependencies.
/// Life cycle of these objects should be the same as the application.
///
/// Warning! Even though the generic constraint is `Any`, this container is only for reference types.
/// Be careful with what you put inside.
///
/// Uses `NSLock` for synchronization between the threads.
public final class Single<T: Any>: IDependency {

    private let builder: () -> T

    private var object: T?
    private let lock = NSLock()

    public init(builder: @escaping () -> T) {
        self.builder = builder
    }

    public func get() -> T {

        if let alreadyBuilt = object { return alreadyBuilt }

        lock.lock()

        if let alreadyBuilt = object { return alreadyBuilt }
        let object = builder()
        self.object = object

        lock.unlock()

        assert(type(of: object) is AnyClass, "Generic type `T` isn't a reference type!")

        return object
    }
}
