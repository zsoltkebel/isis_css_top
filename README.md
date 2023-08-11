# isis_css_top

Top level repository for build of cs-studio with isis customisations

# Developer build (maven)

```
git clone --recursive https://github.com/ISISComputingGroup/isis_css_top.git
build.bat
```

To build without an initial clean use
```
build.bat noclean
```

To save time if you have already done a full build and 
subsequently only modify the `cs-studio\product\repository` area you can use
```
build.bat noclean products
```

Uncomment line to add `-e -X` flags to maven in `build.bat` for debugging information
  
# Developer build (eclipse)

First you will need to build via maven as above.

Next:
- Create a new target platform definition
- Add the following directories to your new target platform definition:
  * `cs-studio-thirdparty/repository/target/repository`
  * `diirt/p2/target/repository`
  * `maven-osgi-bundles/repository/target/repository`
  * `org.csstudio.display.builder/repository/target/repository`
  * `org.csstudio.sns/repository/target/repository`
- Set it as the "active" target platform definition
- Next, import all of the features from `org.csstudio.sns` into your IDE
- Under `org.csstudio.sns/repository` find `basic-epics.product`
- Open this product and synchronize it with the current target platform state
- Click on the "contents" tab, and for each feature that can't be resolved:
  * Import the relevant **feature** projects into eclipse. Note, you do not need to import the plugins themselves, just the features that define them are sufficient.
- Ensure all imported projects are set to use JDK8 with a compiler compliance of 1.8. Also ensure that [your java 8 installation is patched with JAVAFX](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Upgrade-Java#additional-optional-steps-for-developer-installations-not-required-on-instruments).
- You should now have a project with no build errors in eclipse - however it will not launch at this time due to dependency version conflicts
- Go into the run configurations menu and select "plugins"
- Add required plugins
- Press validate plugins. This may report some errors, you need to fix these. Sometimes eclipse selects a newer dependency version when it actually required an older one.
- Ensure the following plugins are added explicitly:
  * `org.eclipse.equinox.ds`
  * `org.eclipse.equinox.event`
- You should now have a validation which reports no errors.
- In the run configurations menu select the box to "clear workspace before launching"
- Press apply and save
- Launch!

# Notes

The CSS repos should be pinned at the following specific versions. Later versions merge in Phoebus code which is incompatible with our code-base so we cannot use them yet (it requires java 11 and java-FX).

- cs-studio-thirdparty: 5d9eb92ced5372c64ac37693ab1f4c16dae01f0f
- diirt: 5baa4d15c546c6df10356a266837a0622b56e423
- maven-osgi-bundles: 174629309dab59ee2852e0272fe31a24cecb41ed
- org.csstudio.display.builder: b8eda4fb6fe27012ff07899d125faa3a29abcc08

The ISIS repos are ok to be on master as we have forks of these.
