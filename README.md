# water-availability

This repository builds the Water Availability in the U.S. website at [https://labs.waterdata.usgs.gov/visualizations/water-availability/](https://labs.waterdata.usgs.gov/visualizations/water-availability). This website is powered by the USGS Vizlab ([portfolio link](https://labs.waterdata.usgs.gov/visualizations/vizlab-home/)).

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

## To reproduce the figures in the website

> Note: You do **not** need to build the R-based figures or datasets to rebuild the website. The repository will build the website using the Vue instructions below. These instructions are for those wanting to reproduce the figures using R directly.

To reproduce the figures in the website that are created in R, you will need to run the targets pipeline. In addition, you do need to run some fetch and processing code from two additional pipelines. 

### Step 1: Clone repositories


Clone the water quality and water use repositories (may need a development branch, contact Althea Archer for assistance) into a folder that contains this repository's directory as well. Should look something like this:

- parent_directory/water-availability/ (this repository)
- parent_directory/iwaas-sparrow-figures/ (water quality repository)
- parent_directory/water-use-huc12-crosswalk/ (water use repository)

The water quality repository is at:  `https://code.usgs.gov/wma/national-iwaas/NWAA/nwaa-1a-releases/iwaas-sparrow-figures/` and the water use repository is at `https://code.usgs.gov/wma/national-iwaas/NWAA/nwaa-1a-releases/water-use-huc12-crosswalk/-/tree/1.0.0/`.

### Step 2: Run the water quality pipeline. 

- Open `parent_directory/iwaas-sparrow-figures/iwaas-sparrow-figures.Rproj`. 
- Run `renv::init()` and choose the first option
- Sign into Sciencebase using the `0_config.R` script.
- Build the pipeline. You do not need to run the entire pipeline, you can run only the requisite components using `targets::tar_make(starts_with("p2_load"))`. 
- This does take a long time to download all of the SPARROW models. If the pipeline seems to be stalled out, you can stop the pipeline with the stop button on RStudio and rerun the `tar_make()` command above. Targets will pick up where the process left off.

### Step 3: Run the water use pipeline. 

- Open `parent_directory/water-use-huc12-crosswalk/water-use-huc12-crosswalk.Rproj`. 
- Run `renv::init()` and choose the first option
- Sign into Sciencebase using the `0_config.R` script.
- Build the pipeline. 
- This might take a while to download files and run. If the pipeline seems to be stalled out, you can stop the pipeline with the stop button on RStudio and rerun the `tar_make()` command above. Targets will pick up where the process left off.

### Step 4: Run the IWAAs website pipeline.

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