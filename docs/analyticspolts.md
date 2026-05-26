# Instructions for Analytics project plot generation

Note: almost all of the MATLAB .m files should work with the native MATLAB documentation viewer. That is, you should be able to see documentation for these files by typing `help [filename]` or by right clicking the name of the function and pressing the "help on" pop-up option.

### Generating Lookuptable objects

1. Ensure you have the `polymer-c` and `ForminKineticModel` repos forked from GitHub
2. Open MATLAB
3. Add all subfolders of `polymer-c` and `ForminKineticModel` to path

   1. You need the `Lookuptable` class files from `ForminKineticModel`, and you need scripts to generate plots in `polymer-c`
4. Load the .mat files containing polymer-c outputs in struct format. You can aquire these by:

   1. Loading pre-made .mat files. These are located in the `PolymerData/` folder (separate from any repository, not under source control).
      1. The files containing the runs used in the Bogue et. al. paper are called `FH2_1.mat`, `FH2_16.mat`, and `FH2_35.mat`, and contain runs for NT-dimerized ("dimer") and non-NT-dimerized ("double") runs for FH1 lengths from 0-600, a dimer distance of 1, and FH2 sizes of 1, 16.667, and 35.5, respectively.
   2. Making .mat files from prior `polymer-c` runs via the `makeLookupMat()` function; See `makeLookupMat.m` for complete documentation
   3. Running new `polymer-c` simulations (see `README.md`, Quickstart) and making new .mat files from the outputs (see above)
5. Generate a `Lookuptable` object by passing the loaded struct object into the constructor for the `Lookuptable` class. In most cases, the struct object will be called `lookuptable`, in which case your command will be:

   ```matlab
   lt=Lookuptable(lookuptable);
   ```

   See `ForminKineticModel/main/Class/@Lookuptable` for more docs

### Plot generation

##### Ideal epsilon plot

See `polymer-c/Analysis/idealepsilonheatmap.m`

Currently only works for single filament ("single") or non-NT-dimerized filaments ("double") runs

### Prvec0 plots

To generate a plot of prvec0 (local effective concentration of binding site at base) values vs distance from FH2 for a fixed FH1 length, use the built in `ltplot` function in the `Lookuptable` class; `Lookuptable.ltplot`

`lt.ltplot('CTdist','Prvec0',1,type="double",FH1=100,scale="amino")` creates a plot of Prvec0 values vs distance from the FH2 domain for non-NT-dimerized ("double") values for an FH1 length of 100 amino acids and scales the prvec0 values to be in units of micromolar (rather than kuhns)

`lt.ltplot('CTdist','Prvec0',1,type="dimer",FH1=500,scale="amino")` creates a plot of Prvec0 values vs distance from the FH2 domain for NT-dimerized ("dimer") values for an FH1 length of 500 amino acids and scales the prvec0 values to be in units of micromolar (rather than kuhns)

`lt.ltplot('CTdist','Prvec0',1,type="single",FH1=200,scale="amino")` creates a plot of Prvec0 values vs distance from the FH2 domain for a single filament ("single") values for an FH1 length of 200 amino acids and scales the prvec0 values to be in units of micromolar (rather than kuhns)

See `Lookuptable.ltplot` for more docs and more plotting options.

### Pocc plots

To generate a plot of Pocc (occlusion at binding site) values vs distance from FH2 for a fixed FH1 length, use the built in `ltplot` function in the `Lookuptable` class; `Lookuptable.ltplot`

`lt.ltplot('CTdist','POcclude',1,type="double",FH1=100)` creates a plot of Pocc values vs distance from the FH2 domain for non-NT-dimerized ("double") values for an FH1 length of 100 amino acids a

`lt.ltplot('CTdist','POcclude',1,type="dimer",FH1=500)` creates a plot of Pocc values vs distance from the FH2 domain for NT-dimerized ("dimer") values for an FH1 length of 500 amino acids

`lt.ltplot('CTdist','POcclude',1,type="single",FH1=200)` creates a plot of Pocc values vs distance from the FH2 domain for a single filament ("single") values for an FH1 length of 200 amino acids

See `Lookuptable.ltplot` for more docs and more plotting options.

### Pocc0 plots

To generate a plot of Pocc0 (occlusion at the base) values vs distance from FH2 for a fixed FH1 length, use the built in `ltplot` function in the `Lookuptable` class; `Lookuptable.ltplot`

`lt.ltplot('length','POcclude',1,type="double",PRM=1)` creates a plot of Pocc0 values vs FH1 length for non-NT-dimerized ("double") values

`lt.ltplot('length','POcclude',1,type="dimer",PRM=1)` creates a plot of Pocc0 values vs FH1 length for NT-dimerized ("dimer") values

`lt.ltplot('length','POcclude',1,type="single",PRM=1)` creates a plot of Pocc0 values vs FH1 length for single filament ("single") values

See `Lookuptable.ltplot` for more docs and more plotting options.

### Notes

Note 1: many lookuptable structs only have dimer and double values and do not contain single runs (since single runs were not repeated for most polymer-c simulations), so you may not be able to generate plots for single from these datasets.

Note 2: the `Lookuptable.ltplot` function does not include the ability to plot analytical equations, only the simualtion data. However, plots of equation data could be easily overlayed on the plots (either by modifying the function itself or by using `hold on`)

### Other useful files

Matlab function files in `polymer-c/Analysis/` that I have previously used to generate plots (may be of use, if at least as a reference):

* `makeprveccalcplot.m`
* `probden_visuals.m`
* `probdencontour_tether.m`
* `probdencontour.m`
* `prvecCalcErrNPlot.m`
* `prvecCalcSimDelLocPlot.m`
* `prvecheatmap.m`

See each file for documentation.
