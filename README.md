# RepoWatcher

## Overview

RepoWatcher is a Swift Widget and associated app following along with the tutorial by Sean Allen. [link](https://seanallen.teachable.com/p/widgets)

It demonstrates API requests within a Swift Widget & SwiftUI, JSON decoding, and testing with fallback data.

## To Get Started

1. Clone the repository
2. Duplicate the `Secrets.template.plist` file to `Secrets.plist`
3. Add your Github API key to the `Secrets.plist` file
    - ⚠️ IMPORTANT: `Secrets.plist` is gitignored and should never be committed
    - Only commit changes to `Secrets.template.plist`
4. In the project assets folder (Widget and App have two separate folders), add an Avatar image named `avatar.png/jpg/jpeg`, thats used as a default image if the avatar placeholder fetch request fails.
5. Run the app

## Security Notes

-   Never commit the `Secrets.plist` file as it contains sensitive API keys
-   The repository includes a `.gitignore` file that excludes `Secrets.plist`
-   Only make changes to `Secrets.template.plist` when adding new secret keys (using placeholder values)
