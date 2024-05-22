# Flakes

A collection of flake templates to use as a starting point in new projects.

## Usage
Add the current flake in user flake registry. 
```
nix registry add <alias> github:brianaung/flakes
```

Check if it has added correctly.
```
nix registry list
```

View the available templates.
```
nix flake show <alias>
```

Create a new flake using a template.
```
# in the current directory
nix flake init -t <alias>#<template>

# (or)

# in the specified directory
nix flake new <project> -t <alias>#<template>
```

## Updating
```
nix flake update <alias>
```
