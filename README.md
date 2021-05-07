# VCDependency

Basic dependency life cycle management.

## Features
- Factory
- Single
- Weak single

## Usage example
```swift
final class Container {

    // The lifecycle of this repository is the same as the lifecycle of the container itself
    lazy var sharedRepository = Single { Repository() }

    // Сontainer weakly references this repo.
    // If the repos was freed from memory, then it will be rebuilt on the next `get()` call.
    lazy var repository = WeakSingle { Repository() }
    
    // Object will be rebuilt on each `get()` call.
    lazy var uniqueRepository = Factory { Repository() }
    
    // Example where objects refer to each other.
    lazy var otherRepository = Single { [sharedRepository] in 
        OtherObject(repository: sharedRepository.get())
    }
}
```

## License
This project is released under the [MIT license](https://en.wikipedia.org/wiki/MIT_License).
