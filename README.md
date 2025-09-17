# Water availability in the United States

> _A newer version of the software may be available. See https://code.usgs.gov/wma/vizlab/water-availability/-/releases to view all releases._

This repository builds the Water Availability in the U.S. website at [https://water.usgs.gov/vizlab/water-availability/](https://water.usgs.gov/vizlab/water-availability). This website is powered by the USGS Vizlab ([portfolio link](https://labs.waterdata.usgs.gov/visualizations/vizlab-home/)).

## Citation

Archer, A.A., Carr, A., Corson-Dosch, H., Jaenicke, M., Azadpour, E., Vaarre-Lamoureux, K., Martinez, A., Nell, C. 2025. Water availability in the United States. U.S. Geological Survey software release. Reston, VA. [https://doi.org/10.5066/P13UMTRM](https://doi.org/10.5066/P13UMTRM)

### About the National Water Availability Assessment

The National Water Availability Assessment is the third assessment developed by the USGS in response to the SECURE Water Act, and the first to present a national, comprehensive assessment of water availability that is inclusive of the amount of water (quantity), the quality of that water, and its use. Water quantity, quality, and use are interrelated and therefore need to be considered together to fully assess water availability. This assessment uses state-of-the-art water quantity, quality, and use models to provide an integrated assessment of water stress across the conterminous United States (CONUS). This evaluation provides new insight on areas of the United States with an imbalance between natural water supply and demand.  

This website complements the National Water Availability Assessment report and features some key messages of the report in an engaging and accessible way. This website was created for a public audience and breaks down some of the technical findings from the report into messages and graphics that can be easily understood. 

### Required Software
- [node.js](http://nodejs.org)
    - `>=0.10.0` (last used: `20.11.0`)
- [git](https://git-scm.com/)
- [R](https://cran.r-project.org/bin/windows/base/)
- [R package targets](https://books.ropensci.org/targets/)
- [R package sbtools](https://cran.r-project.org/web/packages/sbtools/index.html)

### Installation

[Clone the repository](https://learn.hibbittsdesign.org/gitlab-githubdesktop/cloning-a-gitlab-repo)

##### Clone with SSH

```bash
git clone git@code.usgs.gov:wma/vizlab/water-availability.git
```

OR

##### Clone with HTTPS

```bash
git clone https://code.usgs.gov/wma/vizlab/water-availability.git
```

## To reproduce the figures in the website with the R pipeline

> Note: You do **not** need to build the R-based figures or datasets to rebuild the website. The repository will build the website using the Vue instructions below. These instructions are for those wanting to reproduce the figures using R directly.

To reproduce the figures in the website that are created in R, you will need to run the `targets` pipeline. In addition, you do need to run some fetch and processing code from two additional pipelines. 

### Step 1: Clone repositories


Clone the water quality, water supply, and water use repositories into a folder that contains this repository's directory as well. Should look something like this:

- parent_directory/water-availability/ (this repository)
- parent_directory/iwaas-sparrow-figures/ (water quality repository) 
    - available from `https://code.usgs.gov/wma/national-iwaas/NWAA/nwaa-1a-releases/iwaas-sparrow-figures/`
- parent_directory/wq-decadal-change-plots/ (groundwater quality repository)
    - available from `https://code.usgs.gov/wma/national-iwaas/NWAA/wq-decadal-change-plots/`
- parent_directory/water-use-huc12-crosswalk/ (water use repository)
    - available from `https://code.usgs.gov/wma/national-iwaas/NWAA/nwaa-1a-releases/water-use-huc12-crosswalk/`
- parent_directory/iwaas-water-supply/ (water supply repository)
    - available from `https://code.usgs.gov/wma/national-iwaas/NWAA/ws-uncertainty-analysis/`


### Step 2: Run the water quality pipeline. 

> Note, Mac and Linux users may have to install some dependencies manually. See the `iwaas-sparrow-figures/Readme.md` for more information

- Open `parent_directory/iwaas-sparrow-figures/iwaas-sparrow-figures.Rproj`. 
- Run `renv::init()` and choose the first option. 
- Sign into Sciencebase using the `0_config.R` script.
- Build the pipeline. You do not need to run the entire pipeline, you can run only the requisite components using `targets::tar_make(starts_with("p2_load"))`. 
- This does take a long time to download all of the SPARROW models. If the pipeline seems to be stalled out, you can stop the pipeline with the stop button on RStudio and rerun the `tar_make()` command above. Targets will pick up where the process left off.

### Step 3: Run the water use pipeline. 

> Note, Mac and Linux users may have to install some dependencies manually. See the `water-use-huc12-crosswalk/Readme.md` for more information

- Open `parent_directory/water-use-huc12-crosswalk/water-use-huc12-crosswalk.Rproj`. 
- Run `renv::init()` and choose the first option
- Sign into Sciencebase using the `0_config.R` script.
- Build the pipeline. 
- This might take a while to download files and run. If the pipeline seems to be stalled out, you can stop the pipeline with the stop button on RStudio and rerun the `tar_make()` command above. Targets will pick up where the process left off.

### Step 4: Run the water supply pipeline. 

> Note, Mac and Linux users may have to install some dependencies manually. See the `ws-uncertainty-analysis/Readme.md` for more information

- Open `parent_directory/ws-uncertainty-analysis/ws-uncertainty-analysis.Rproj`. 
- Run `renv::init()` and choose the first option
- Sign into Sciencebase using the `0_config.R` script.
- Build the pipeline `tar_make(p3_c404_precip_csv)`. 
- This might take a while to download files and run. If the pipeline seems to be stalled out, you can stop the pipeline with the stop button on RStudio and rerun the `tar_make(p3_c404_precip_csv)` command above. Targets will pick up where the process left off.

### Step 5: Run the groundwater quality pipeline. 

> Note, Mac and Linux users may have to install some dependencies manually. See the `wq-decadal-change-plots/Readme.md` for more information

- Open `parent_directory/wq-decadal-change-plots/wq-decadal-change-plots.Rproj`. 
- Run `renv::init()` and choose the first option
- Sign into Sciencebase using the `0_config.R` script.
- Build the pipeline `tar_make(p2_overview_inorg_threshold_belitz)`. 
- This might take a while to download files and run. If the pipeline seems to be stalled out, you can stop the pipeline with the stop button on RStudio and rerun the `tar_make(p2_overview_inorg_threshold_belitz)` command above. Targets will pick up where the process left off.

### Step 6: Run the IWAAs website pipeline.

- Open `parent_directory/water-availability/water-availability.Rproj`. 
- Sign into Sciencebase using the `0_config.R` script.
- Build the pipeline. 
- This might take a while to download files and run. If the pipeline seems to be stalled out, you can stop the pipeline with the stop button on RStudio and rerun the `tar_make()` command above. Targets will pick up where the process left off.


## To build the website

Inside of your repository directory:

```bash
npm install
```

### Building and testing

Serve files locally:

```bash
npm run dev
```

Build for production deployment:

```bash
npm run build
```

Run server in production environment (after `npm run build`):
```bash
npm run start
```

- serves the previously built and optimized version of the site


Local site: http://localhost:5173/visualizations/water-availability/

### Development Workflow

Document development issues via git, and use to steer your workflow:

1. Create a branch based on the `main` branch using a descriptive branch name.
2. Work on the issue on your branch.
   1. Run a live version of the app while you work: `npm run dev`
   2. Add your changes with the command `git add .`
   3. Frequently commit your changes to your local branch with a short, descriptive message. Include the issue number to easily reference commit history from the issue page. Example: `git commit -m "#3 Adds README"`
   4. Frequently push your local changes to the remote repository in GitLab `git push origin branchname`
4. Ensure your code is synced with the latest version of the `main` branch before submitting a [Merge Request](https://code.usgs.gov/wma/vizlab/water-availability/-/merge_requests):
   1. Use the command `git pull origin main`
   2. If there are no merge conflicts, the updates made to the `main` branch will be incorporated into your local branch automatically.
   3. If there are merge conflicts, you will need to resolve these manually. Please be careful with this step so that no code is lost. Once complete, you will need to add your changes: `git add .` and then commit again: `git commit -m "add message here"`
   4. Push any changes to GitLab: `git push origin branchname`
5. Submit a [Merge Request](https://code.usgs.gov/wma/vizlab/water-availability/-/merge_requests):
   1. Request that your branch be merged into the `main` branch.
   2. Name the Merge Request in this format: "Fixes #5 - Issue Description".
   3. Use [keywords](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#:~:text=To%20automatically%20close%20an%20issue,fix%2C%20fixes%2C%20fixed%2C%20fixing) to automatically close issues (e.g. "Closes #5).
   4. Assign a developer to review the Merge Request.
6. Once your Merge Request is reviewed, address any feedback that needs to be addressed. Once you have addressed feedback, click the button to re-request review.
7. Upon approval of the Merge Request, your issue will be merged into the `main` branch and you can start on a new issue.

### Built With

- [Vue.js](https://vuejs.org/) - The main web framework used
- [NPM](https://www.npmjs.com/) - Dependency Management