# water-availability



### Required Software
- [node.js](http://nodejs.org)
    - `>=0.10.0` (last used: `20.11.0`)
- [git](https://git-scm.com/)
- [R](https://cran.r-project.org/bin/windows/base/)
- [R package targets](https://books.ropensci.org/targets/)

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

## To build the figures in R Pipeline

To run this pipeline:

1. Verify that you have read access to the ScienceBase repository at: https://www.sciencebase.gov/catalog/item/643706ffd34ee8d4addcc593
2. If you don't have access to that site, contact Anthony Martinez for read-access
3. Once you have access, open `0_config.R` and run the code after changing out your username. Please do not commit this change. This will ask you to provide your username, and then an API token. Make sure you don't have pop-ups blocking this process and that you're connected to VPN.
4. Then, `targets::tar_make()` should produce two svg files, which are located in the `src/assets/svgs/` folder. Please open those in a web browser or Illustrator and verify that they look like this:


## To build website

Inside of your project folder (after clone and building the pipeline):

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

Document development issues via GitLab, and use to steer your workflow:

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