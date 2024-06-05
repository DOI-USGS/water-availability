## Navigation logic

#### Big Picture
- Logic is located in the `PageCarousel.vue`
- Info (routes, page numbers, and key messages) is located in `Subpages.js`
    - Key messages can be updated directly in this js file and will be replaces whereever they appear
- All of the buttons (the numbers, arrows, and Return to Main) are buttons linking to routes corresponding to the correct pages. 

#### Definitions and Details
- `lowNumber` is the first number visible on the page
- `middleNumber` is the center number (the current page you're on)
- `highNumber` is the third and final number on the page
(`highIndex`, `middleIndex`, and `highIndex` refer to the index of the object that should be pulled from `SubPages.js`)
(same thing for `lowRoute`, `middleRoute`, and `highRoute`, but these correspond to the router links that will take you to the correct page)

- `showLeftArrow` and `showRightArrow` are used to add or remove arrows if you're at page 1 or 10, since you don't need a left arrow on page 1 and you don't need a right arrow on page 10
    - in the html, we use `v-if` to dynamically decide whether to show those arrow buttons
- `showHomeButton____` is used to decide where the home button should be. If we're on page 1 or 10, it won't be in the middle. 
    - in the hntl, we use `v-if` to dynamically decide where to put the home button based on the boolean values we've assign to `showHomeButtonLeft`, `showHomeButtonMiddle`, and `showHomeButtonRight` in the logic
- `CurrentRouteId` is a variable that aids in determining which page we're on and is used in a lot of the logic for showing/hiding certain buttons

