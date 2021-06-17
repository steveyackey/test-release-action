#!/bin/bash
set -eo pipefail

if [[ -n "${INPUT_INITIAL_TAG}" ]]; then
    current_tag="$(echo ${INPUT_INITIAL_TAG} | grep v[0-9\.].* || echo "")"
    echo "Original Input: ${INPUT_INITIAL_TAG}"
else
    current_tag=$(git tag -l --sort=-v:refname | grep v* | head -n 1 || echo "")
fi 
echo "Current Tag: $current_tag"

echo "Commit message: $INPUT_COMMIT_MESSAGE" 

if [[ -z "$current_tag" ]]; then
  resulting_semver_tag="v1.0.0"
elif [[ "$INPUT_COMMIT_MESSAGE" == *"#major"* ]]; then
  resulting_semver_tag="v$(npx semver -c -i major $current_tag)"
elif [[ "$INPUT_COMMIT_MESSAGE" == *"#minor"* ]]; then
 resulting_semver_tag="v$(npx semver -c -i minor $current_tag)"
else
 resulting_semver_tag="v$(npx semver -c -i patch $current_tag)"
fi

resulting_major_version="${resulting_semver_tag%%.*}"

echo "✅ Resulting semantic version tag: ${resulting_semver_tag}"
echo "✅ Resulting major version tag: ${resulting_major_version}"

echo "::set-output name=initial-tag::$current_tag"
echo "::set-output name=resulting-semver-tag::$resulting_semver_tag"
echo "::set-output name=resulting-major-version-tag::$resulting_major_version"

if [[ "$INPUT_DRY_RUN" == "true" ]]; then
  echo "Dry-run enabled. Skipping tagging commit."
  exit 0 
fi

git tag $resulting_semver_tag
git tag ${resulting_semver_tag%%.*} -f
git push --tags -f