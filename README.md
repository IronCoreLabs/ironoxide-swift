# IronOxide Swift

Swift SDK for using IronCore Labs from your iOS mobile applications.

## Setup

Building this library is pretty manual at the moment and takes a lot of steps. We're still figuring out how it all works.

+ Build the C/C++ bindings via the [IronOxide Java repo](https://github.com/IronCoreLabs/ironoxide-java)
    + Go into the `cpp` directory and run `cargo build --release`. This will generate a bunch of C/C++ header files in a `sdk/generated` folder as well as generate a `.dylib` or `.so` in the `ironoxide-java/target/release/` directory.
+ Install Swift via the [recommended method](https://swift.org/getting-started/#installing-swift)
+ Open up the `Sources/libronoxide/ironoxide.h` file and change all of the paths in that file to point to the `ironoxide-java/cpp/sdk/generated` directory on your machine. We haven't yet figured out how to make it so those paths can be relative or the directory provided via a flag when compiling with Swift.
+ Now you can compile this project via `swift build -Xlinker -L{path_to_your_ironoxide_target_release_directory}`. If successful this should generate a `.build` directory which is similar to the `target` directory generated in Rust projects.

The reason that we need to provided the `-Xlinker` option is to tell Swift where our native library is. By default Swift looks in expected `/usr/local/` or similar directories. Because our ironoxide binary isn't installed globally on your machine, that won't work. This is the same with the header files as well, we just don't yet know how to tell Swift to look in our custom location, hence the fully qualified include paths.

## Adding Library to iOS Project in XCode

XCode dependencies are added via URLs, usually pointing directly to a GitHub repository. You can also use the `file://` protocol to have it point to a local library on disk.

+ In your iOS app in XCode, select `File -> Swift Packages -> Add Package Dependency..`.
+ In the popup, either enter the URL to this repo, or use the `file://` syntax to point to the directory of your checked out repo.
+ Pick the tag/branch/rev you want to point to and add the dependency.
+ Now we have to include the native library to the project. Click on your iOS project and select the `Build Settings` tab. Click the `All` option to show all values, then scroll down to the `Search Paths` section. Add an option to the `Library Search Paths` and put in the fully qualified path to your `ironoxide-java/target/release/` directory.

Once complete, you should be able to do `import ironoxide` in your Swift files and use the SDK.