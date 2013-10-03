# Pivotal Stats

Example library in Haskell for aggregating data from the Pivotal Tracker API.

## Compilation

    cabal configure && cabal build && cabal install

## Usage

Set an environment variable for TRACKER_TOKEN. Call pivotal-stats with a project
id:

    pivotal-stats 12345

pivotal-stats will return the number of chores, features and bugs in the last
100 stories in your project.
