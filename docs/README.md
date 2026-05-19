# polymer-c

---

## Repository Organization

* `polymer-c/`

  - `Analysis/` contains (primarily MATLAB) files that generate figures/ do calculations using the output of driveMetropolis.c as input.
  - `docs/` contains documentation files, including the PolymerCode flowchart and outputControl format .txt file.
  - `drivers/` contains scripts for submitting jobs to HPC and looping through variables
  - `Gillespie/` contains C scripts for running the reversible and irreversible Gilespie simulations
  - `src/PolymerCode/` contains C scripts for running metropolis algorithm, as well as .txt files for parameters

---

## Quickstart

To run on UCI hpc3:

* go to `polymer-c/src/PolymerCode`
* run  `gcc -O3 driveMetropolis.c -o metropolis.out -lm`
* See `drivers/testslurm.sub` for a sample submission script
  * When modifying this, make sure the account name and e-mail address are correct
  * For most "dimer" runs, the runtime limit should be set to the full 14 days
* Use a bash script to easily submit runs
  * Multiple .sh files in `drivers/` already exist and can be modified accordingly. These files mostly work by iteratively modifying `testslurm.sub` and creating a separate directory for each of the new runs.
  * If using one of these scripts, be sure to modify any paths specified (mostly in the variable `output_dir`, but also in various `cd` statements)
* Run `bash [bash script].sh`
* Check your job with `squeue -u [yourusername]` or `sacct`

How to run simulations with and without occupied binding sites:

* Whether base occlusion is used is controled by the global variable `MULTIPLE` defined in `src/PolymerCode/driveMetropolis.c`
  * setting this to 1 will turn on occupied binding sites, setting this to 0 will turn off occupied binding sites
  * Remember: after modifying `src/PolymerCode/driveMetropolis.c`, the code needs to be recompiled in order for those changes to be reflected
* Settings for occupied binding sites are set in `src/PolymerCode/parameters.txt`
  * `brLigand` radius of bound ligands
  * `occupiedSites` bound site locations if `bSiteInputMethod`=2
  * `occupiedSitesNoSpace` bound site locations if `bSiteInputMethod`=2
  * `bSiteFilename` file that specified bound site locations (only used if `bSiteInputMethod`=3)
    * 1 line per filament with bound site locations separated by commas
    * to specify no bound sites, use a blank line or line with -1
  * `bSiteInputMethod`
    * 0 = bound site locations hard coded into `rc/PolymerCode/getiSites.c`
    * 1 = bound sites specified via command line (I do not think this is currently functional)
    * 2 = bound sites specified via `occupiedSites` and `occupiedSitesNoSpace`
    * 3 = read bound sites from file
    * 4 = use the last site as the only bound site

How to run simulations with and without occlusion at the base:

* Note about coordinates: 3D coordinates are established by indexing into variables. For ease of understanding, let's say x= index 0, y= index 1, and z= index 2. The code currently places the base of filament 1 at 0,0,0 and the base of filament 2 at `baseSepDistance`,0,0
* Whether base occlusion is used is controled by the global variable `BASEBOUND` defined in `src/PolymerCode/driveMetropolis.c`
  * setting this to 1 will turn on base occlusion, setting this to 0 will turn off base occlusion
  * Remember: after modifying `src/PolymerCode/driveMetropolis.c`, the code needs to be recompiled in order for those changes to be reflected
* Settings for base occlusion are set in `src/PolymerCode/parameters.txt`
  * `baseboundtype`
    * 0 = sphere located at the base of filament #1 (centered at 0,0,`-baserLigand`)
    * 1 = sphere centered 0.5*`baseSepDistance` away from filament #2 (when two filaments are used, this means the sphere is located at the center of the two filaments) (centered at 0.5* `baseSepDistance`,0,`-baserLigand`)
    * 2 = plane at the base of the filament(s) (occludes everything z<0)
    * 3 = cylinder centered 0.5*`baseSepDistance` away from filament #2 (when two filaments are used, this means the sphere is located at the center of the two filaments) with a height extending from the base to -infinity (occludes everything where z<0 and (0.5* `baseSepDistance`-x)^2+y^2)<= (`baserLigand`)^2)
  * `baserLigand` radius of the bound object at the base (not relevent for the plane)
* `drivers/Submitbash_bni1.sh` is an example script that submits HPC3 runs for every possible combination of bound binding sites for the formin BNI1 (this script is a bit messy, but may be a useful reference)

How to modify output of iterations for movie making:

* If `verboseTF` is set to true, the code will output additional files that record the location of bound sites, bases, and each joint of each chain for a sample of iterations
  * `verboseTF` is a command line input parameter
* How many iterations are recorded and the step size between iterations is set in `src/PolymerCode/outputControl.c`
  * currently line 1098: `if ( (nt>NTCHECK&&nt<=NTCHECK+301000&& (nt%1000) ==0) )`
  * to set the step size to X and the number of iterations to Y, modify this line to read: `if ( (nt>NTCHECK&&nt<=NTCHECK+[X*Y+X]&& (nt%X) ==0) )`
  * Remember: after modifying `src/PolymerCode/outputControl.c`, the code needs to be recompiled in order for those changes to be reflected
* If you wish to run the code to just generate these iterations files (rather than run the metropolis algorithm to completion), set the global variable `NTMAX` in `src/PolymerCode/driveMetropolis.c` to `NTCHECK+[X*Y+X]`
  * Remember: after modifying `src/PolymerCode/driveMetropolis.c`, the code needs to be recompiled in order for those changes to be reflected
* The additonal output files are as follows, with the extension following the default output file name specified:
  * `_base.txt` locations of the filament bases
  * `_bound.txt` locations of the bound ligands
  * `_locs.txt `locations of each filament joint
  * `_VisualParameters` misc recording, only creates if global variable `VISUALIZE` = 1 in `src/PolymerCode/driveMetropolis.c`
