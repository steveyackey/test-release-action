# semver-bump-action
A GitHub Action for bumping the semantic version tag.

This action requires the usage of the `actions/checkout@v2` action before bumping your semantic version tag. In order to bump a specific part of the version, 
you can use `#patch` (which is the default), `#minor`, or `#major` in your commit message. 

When pushing the tags it will tag both the full semantic version, as well as the shortened major version number, prefixed with `v`. For example, if your commit states:

```
"Added this new feature #minor"
```

Assuming your previously tagged version is `v1.0.1`, your commit would be tagged with:
- `v1.1.0`
- `v1`