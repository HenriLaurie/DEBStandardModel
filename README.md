# DEBStandardModel.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/HenriLaurie/DEBStandardModel.jl.svg?branch=master)](https://travis-ci.com/HenriLaurie/DEBStandardModel.jl)
[![codecov.io](http://codecov.io/github/HenriLaurie/DEBStandardModel.jl/coverage.svg?branch=master)](http://codecov.io/github/HenriLaurie/DEBStandardModel.jl?branch=master)
<!--
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://HenriLaurie.github.io/DEBStandardModel.jl/stable)
[![Documentation](https://img.shields.io/badge/docs-master-blue.svg)](https://HenriLaurie.github.io/DEBStandardModel.jl/dev)
-->

So far, only a demo module has been added: `AmPdemo.jl`. It plots length versus (metabolic) age in the scaled variables of equations (2.26) to (2.28)
of the DEB book (3rd ed).

I can't get the tests to work properly: if I issue `include("test/runtests.jl")` then the tests pass, but if I issue `Pkg.test("DEBStandardModel")` it fails to find the data file the tests use.

Also, I'm afraid I don't know how get the bots to work: I used to get compat errors (deleted them all, can't post details) and I am sure they're still there but the automated messages have stopped.
