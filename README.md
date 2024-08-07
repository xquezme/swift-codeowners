# swift-codeowners

Command Line Interface (CLI) based set of tools written in Swift for [GitHub's](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/about-code-owners#codeowners-syntax) and [GitLab's](https://docs.gitlab.com/ee/user/project/codeowners/reference.html) `CODEOWNERS` files.

## Installation

### Installing from source

You can also build and install from source by cloning this project and running
the following script (Xcode 15.4 or later).

Manually
Run the following commands to build and install manually:

```
$ git clone git@github.com:xquezme/swift-codeowners.git
$ cd swift-codeowners
$ swift build -c release --disable-sandbox
```