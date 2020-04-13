# IronOxide Swift

## Setup

Getting this repo up and running takes a number of steps, from compiling the C headers and binary, getting XCode setup properly, and configuring the project correctly. 

### Building C Header Files and iOS Binary

+ Go to ironoxide-java and go into the `cpp` directory.
+ Add the iOS emulator target to your build chain: `rustup target add x86_64-apple-ios`
+ Change the `Cargo.toml` file so that we build a static library, e.g. `crate-type = ["staticlib"]`
+ Run `cargo build --target x86_64-apple-ios --release`. If you get an error about `"iphonesimulator" cannot be located` or similar, open up XCode -> Preferences -> Locations and make sure the `Command Line Tools` selectbox has an option selected.
+ After building, you should have a `generated/sdk` directory full of various files and also a `libironoxide_shared.a` file under the `ironoxide-java/target/x86_64-apple-ios/release/` directory. Make note of those two directories.

### Opening Project in XCode

+ Open up XCode and either select your existing project or click the "Open another project" and select the `ironoxide-swift.xcodeproj` file to open the project.
+ Click on the `ironoxide-swift` top item in your code sidebar and it should open up a bunch of project settings. From here:
    - Click the "Build Settings" option and change the sub menu from "Basic" to "All". Scroll down to the `Search Paths` settings and under `Library Search Paths` add a new item under the `Debug` option. The value is the fully qualified location of your `ironoxide-java/target/x86_64-apple-ios/release/` directory.
    - In the `User Header Search Paths` section, add a new item under the `Debug` option. The value is the fully qualified location of your `ironoxide-java/cpp/generated/sdk` directory.
+ Click the `Build Phases` tab from the top. Expad the `Link Binary Wih Libraries` section and click the `+` button. From the popup, search for `libresolv` and select the `libresolv.tbd` option. Click the `+` button again and  select the `Add Other -> Add Files`. Go to your `ironoxide-java/target/x86_64-apple-ios/release/` directory and select the `libironoxide_shared.a` file.

Complete! From here you should be able to click the build button in XCode to startup the app.
