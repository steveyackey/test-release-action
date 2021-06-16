# semver-bump-action
A GitHub Action for bumping the semantic version tag. We recommend using `patriotsoftware/semver-bump-action@v1` to get the latest changes.
If new features require breaking changes, we will release them to `@v2`. You can also use a full semantic version tag. 

This action requires the usage of the `actions/checkout@v2` action before bumping your semantic version tag, using a fetch-depth of zero:
```
- uses: actions/checkout@v2
  with:
    fetch-depth: 0
```

In order to bump a specific part of the version, you can use `#patch` (which is the default), `#minor`, or `#major` in your commit message. 

When pushing the tags it will tag both the full semantic version, as well as the shortened major version number, prefixed with `v`. For example, if your commit states:

```
"Added this new feature #minor"
```

Assuming your previously tagged version is `v1.0.1`, your commit would be tagged with:
- `v1.1.0`
- `v1`

## Example Usage

```
- uses: actions/checkout@v2
  with:
    fetch-depth: 0
- uses: patriotsoftware/semver-bump-action@v1
```

### Additional Inputs

```
inputs:
  dry-run:
    description: "Value: true/false. When true, it doesn't tag the commit, it only outputs what would've been tagged."
    required: false
    default: "false"
  initial-tag:
    description: "Used to override the initial tag to bump up from"
    required: false
  commit-message:
    description: "Used to override the commit message. Generally used for testing the action."
    required: false
```

### Available Outputs
```
outputs:
  current-tag:
    description: "The latest tag prior to updating found by 'git tag -l'"
  resulting-semver-tag:
    description: "The full resulting tag in semver format (v1.0.0)"
  resulting-major-tag:
    description: "The resulting full major version (v1)"
```

To see how to use outputs from the steps, you can look at our `test-action.yml` workflow within this repository. 