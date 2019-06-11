# isis_css_top

Top level repository for build of cs-studio with isis customisations

# Developer build

```
git clone --recursive https://github.com/ISISComputingGroup/isis_css_top.git
build.bat
```

# Notes

The CSS repos should be pinned at the following specific versions. Later versions merge in Phoebus code which is incompatible with our code-base so we cannot use them yet (it requires java 11 and java-FX).

- cs-studio-thirdparty: 5d9eb92ced5372c64ac37693ab1f4c16dae01f0f
- diirt: 5baa4d15c546c6df10356a266837a0622b56e423
- maven-osgi-bundles: 174629309dab59ee2852e0272fe31a24cecb41ed
- org.csstudio.display.builder: b8eda4fb6fe27012ff07899d125faa3a29abcc08

The ISIS repos are ok to be on master as we have forks of these.
