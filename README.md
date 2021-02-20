# skeleton-builder
GitHub Action to create fully functional skeleton packages that include all the necessary dependencies

## Development / Debugging
This `action` comes with a built-in workflow that helps with development. By using [act](https://github.com/nektos/act), it can be entirely run locally, without the need of pushing to GitHub.

To run the action locally, open your terminal and `cd` to the location of this file, then simply run `act`.

Act will run the built-in workflow which is set to point to the `entrypoint.sh` file at this location. Any change applied to the file can be tested by re-running `act`.