# IronOxide Swift

Swift SDK for using IronCore Labs from your iOS mobile applications.

## Building and Testing

Building this library is pretty manual at the moment and takes a lot of steps. We're still figuring out how it all works.

- This repo should be checked out as a sibling of the [IronOxide Java repo](https://github.com/IronCoreLabs/ironoxide-java).
- Build the C/C++ bindings within your `ironoxide-java` checkout
  - [Mac] Go into the `cpp` directory and modify the `Cargo.toml` file to build a `staticlib` instead of a `cdylib`
  - Run `cargo build --release`. This will generate a bunch of C/C++ header files in a `sdk/generated` folder as well as generate a library binary in the `ironoxide-java/target/release/` directory.
  - [Linux] Set the environment variable `LD_LIBRARY_PATH` to the `ironoxide-java/target/release` folder
- Install Swift via the [recommended method](https://swift.org/getting-started/#installing-swift). You should have at least Swift 5.2 installed.
- Now you can compile this project via `swift build`. If successful this should generate a `.build` directory which is similar to the `target` directory generated in Rust projects. You should also be able to run the tests via `swift test` as well (Linux users will need to run `swift test --enable-test-discovery`).

## VSCode Setup

- Install [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) binaries.
- Install the [SwiftLint](https://marketplace.visualstudio.com/items?itemName=vknabel.vscode-swiftlint) and [SwiftFormat](https://marketplace.visualstudio.com/items?itemName=vknabel.vscode-swiftformat) extensions. If you don't have it enabled already, enable the `Format on Save` option in VSCode.
- Clone the [sourcekit-lsp extension](https://github.com/apple/sourcekit-lsp). Then follow the [instructions](https://github.com/apple/sourcekit-lsp/tree/master/Editors/vscode) for how to build and install the extension into VSCode. In order for this extension to work you'll need to have the `sourcekit-lsp` binary that came with your Swift installation in your path.

## Adding Library to iOS Project in XCode

XCode dependencies are added via URLs, usually pointing directly to a GitHub repository. You can also use the `file://` protocol to have it point to a local library on disk.

- Compile the `ironoxide-java` binary for the `x86_64-apple-ios` target. From the `ironoxide-java/cpp` directry run `cargo build --release --target x86_64-apple-ios`
- In your iOS app in XCode, select `File -> Swift Packages -> Add Package Dependency..`.
- In the popup, either enter the URL to this repo, or use the `file://` syntax to point to the directory of your checked out repo.
- Pick the tag/branch/rev you want to point to and add the dependency.
- Now we have to include the native library to the project. Click on your iOS project and select the `Build Settings` tab. Click the `All` option to show all values, then scroll down to the `Search Paths` section. Add an option to the `Library Search Paths` and put in the fully qualified path to your `ironoxide-java/target/x86_64-apple-ios/release/` directory.

Once complete, you should be able to do `import IronOxide` in your Swift files and use the SDK.

## Generating Docs

We use [jazzy](https://github.com/realm/jazzy) to generate an HTML version of our API docs. Jazzy requires Ruby and can be installed with `[sudo] gem install jazzy`.
On a Mac, the docs can be generated simply by running `jazzy --module IronOxide` from the root of the repository. This will generate a `docs/` folder that contains the html files. To run jazzy on Linux, additional steps for installing and running can be found [here](https://github.com/realm/jazzy#linux).
