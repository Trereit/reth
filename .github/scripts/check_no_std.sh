#!/usr/bin/env bash
set -eo pipefail

# Define packages that need to be built with no_std
no_std_packages=(
  # Uncomment and add your packages here
  # reth-codecs
  # reth-consensus
  # reth-db
  # reth-errors
  # reth-ethereum-forks
  # reth-evm
  # reth-evm-ethereum
  # reth-network-peers
  # reth-primitives
  # reth-primitives-traits
  # reth-revm
)

# Ensure there are packages to build
if [ ${#no_std_packages[@]} -eq 0 ]; then
  echo "No packages specified for build."
  exit 1
fi

# Iterate over each package and build it
for package in "${no_std_packages[@]}"; do
  cmd="cargo +stable build -p $package --target riscv32imac-unknown-none-elf --no-default-features"

  if [ -n "$CI" ]; then
    echo "::group::$cmd"
  else
    printf "\n%s:\n  %s\n" "$package" "$cmd"
  fi

  # Execute the build command
  if ! $cmd; then
    echo "Build failed for package: $package"
    exit 1
  fi

  if [ -n "$CI" ]; then
    echo "::endgroup::"
  fi
done

echo "Build process completed for all packages."
