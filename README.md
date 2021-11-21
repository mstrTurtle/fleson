# fleson

## Abstract

Well well well. My friend.

This is Yet Another Homework of Compiler Course(So it calls YAHCC:fearful:).

To learn how it works, and what it is used for, straightly read CMakeLists.txt and demo.sh.

Lots of Template Meta Programming Skill used in slice.h, and I'm sure you'll have fun:joy_cat:

## Compile

Compile the project using cmake commands listed below:

```bash
$ cmake -H. -Bbuild
$ cmake --build build
```

Target could be found `/build/bin/fleson` now.

## Install

### UNIX-Like Platform

On UNIX-like platform, copy `fleson` directly to `/usr/bin`

```bash
$ cp ./build/bin/fleson /usr/bin/fleson
```

### Windows

On Windows, copy it to somewhere else, then add the directory to System Path.
