# IronOxide Swift

Swift SDK for using IronCore Labs from your iOS mobile applications.

## Setup

- Install `libironoxide` via Homebrew with `brew install IronCoreLabs/ironcore/ironoxide`.
- Within XCode, go to `File > Swift Packages > Add Package Dependency`. Put in the URL for this GitHub repo and select the latest version to use. Then go to your build target `Build Phases > Dependencies` and select `IronOxide` from the list. Then you'll be able to `import IronOxide` into your XCode project.

## SDK Documentation

TODO

## Building and Testing on MacOS/Linux

Building and testing this library to run on MacOS/Linux varies pretty heavily depending on what architecture you are building for.

- Install Swift via the [recommended method](https://swift.org/getting-started/#installing-swift). You should have at least Swift 5.2 installed.
- This repo requires artifacts from building the [IronOxide Swig Bindings repo](https://github.com/IronCoreLabs/ironoxide-swig-bindings) so you'll need to have that repo checked out.
- Build the C/C++ bindings within your `ironoxide-swig-bindings/cpp` checkout
  - Run `cargo build --release`. This will generate a bunch of C/C++ header files in a `sdk/generated` folder as well as generate a library binary in the `ironoxide-swig-bindings/target/release/` directory.
  - Generate a bunch of symlinks on your system so that the library can find the `libironoxide` binary and headers. This step will go away once we publish `libironoxide` for MacOS on Homebrew and other various Linux package managers (apt, etc).
    - Add a symlink in your `/usr/local/lib` directory to point to the `.dylib` created above: `ln -s /path/to/ironoxide-swig-bindings/target/release/libironoxide.dylib libironoxide.dylib`.
    - Add a symlink in your `/usr/local/include/` directory to point to the C header files directory above: `ln -s /path/to/ironoxide-swig-bindings/cpp/generated/sdk ironoxide`.
    - Add a symlink in your `/usr/local/lib/pkgconfig` (or `/usr/lib/pkgconfig` on Linux) directory to point to the `.pc` file in the `ironoxide-swig-bindings` repo: `ln -s /path/to/ironoxide-swig-bindings/cpp/ironoxide.pc.in libironoxide.pc`
- Now you can compile this project via `swift build`. If successful this should generate a `.build` directory. You should also be able to run the tests via `swift test` as well (Linux users will need to run `swift test --enable-test-discovery`).

## VSCode Setup

- Install [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) binaries.
- Install the [SwiftLint](https://marketplace.visualstudio.com/items?itemName=vknabel.vscode-swiftlint) and [SwiftFormat](https://marketplace.visualstudio.com/items?itemName=vknabel.vscode-swiftformat) extensions. If you don't have it enabled already, enable the `Format on Save` option in VSCode.
- Clone the [sourcekit-lsp extension](https://github.com/apple/sourcekit-lsp). Then follow the [instructions](https://github.com/apple/sourcekit-lsp/tree/master/Editors/vscode) for how to build and install the extension into VSCode. In order for this extension to work you'll need to have the `sourcekit-lsp` binary that came with your Swift installation in your path.

## Generating Docs

We use [jazzy](https://github.com/realm/jazzy) to generate an HTML version of our API docs. Jazzy requires Ruby and can be installed with `[sudo] gem install jazzy`.
On a Mac, the docs can be generated simply by running `jazzy --module IronOxide` from the root of the repository. This will generate a `docs/` folder that contains the html files. To run jazzy on Linux, additional steps for installing and running can be found [here](https://github.com/realm/jazzy#linux).

## Test

Test section added so I can tell if the README changed
