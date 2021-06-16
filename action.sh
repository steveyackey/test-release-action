#!/bin/bash
set -eo pipefail

current_tag=$(git tag -l --sort=-v:refname | grep v* | head -n 1)
echo "Current Tag: $current_tag"

echo "Commit message: $INPUT_COMMIT_MESSAGE" 

if [[ -n "${INPUT_INITIAL_TAG}" ]]; then
    resulting_semver_tag="${INPUT_INITIAL_TAG}"
elif [[ "$INPUT_COMMIT_MESSAGE" == *"#major"* ]]; then
  resulting_semver_tag="v$(npx semver -c -i major $current_tag)"
elif [[ "$INPUT_COMMIT_MESSAGE" == *"#minor"* ]]; then
 resulting_semver_tag="v$(npx semver -c -i minor $current_tag)"
else
 resulting_semver_tag="v$(npx semver -c -i patch $current_tag)"
fi

# Double check that the semver is set correctly, if not, fall back to 1.0.0
if [[ "$resulting_semver_tag" == "" ]]; then
 resulting_semver_tag="v1.0.0"
fi

resulting_major_version="${resulting_semver_tag%%.*} "

echo "::set-output name=initial-tag::$current_tag"
echo "::set-output name=resulting-semver-tag::$resulting_semver_tag"
echo "::set-output name=resulting-major-version::$resulting_major_version"

if [[ "$INPUT_DRY_RUN" == "true" ]]; then
  echo "Dry-run enabled."
  exit 0 
fi

git tag $resulting_semver_tag
git tag ${resulting_semver_tag%%.*} -f
git push --tags -f