# StackOverflowUsers Take-Home

Thank you so much for this opportunity!  I really enjoyed working on this project and I hope you appreciate it.  All requirements are complete and are listed below.

## Installation

```
pod install
```

## Fetching Data

To fetch the data I used RxAlamofire and made an extension to automatically create an Observable of the result fetched from the endpoint.  If it was successful in fetching the data (and mapping to a Decodable object) then it returned the Decodable object.  Otherwise, it returns an error to be consumed by the UI that will then display an alert to the user.

## TableView

The tableView is set up using RxCocoa (since we're only dealing with one type of cell), so there was no need to create a unique datasource or delegate in order to organize our tableView.  In addition, the cells are configured using a specific method that takes in a ViewModel and assigns data to labels based on the data in the viewModel.  Since there are some observables that are created within this method, our dispose bag is re-initialized in the cell's "prepareForReuse" method.  This is done in order to keep our memory footprint low by deallocating observable streams of cells that are off screen.

## Cell Display

Cells display the profile image, badges (using the star fill system icon and a unique color), and the username of each user.

## Handling Images

Every image has an associated loading indicator while data is being downloaded and, using Kingfisher, images are stored on disk or in RAM to be quickly loaded to the user (limiting the number of network requests).  However, even though images may be stored on disk, the user JSON still needs to be fetched.  In a production application, this JSON would likely be stored so that data can be displayed regardless of internet connectivity (so long as the user has downloaded the JSON before).

## Responsive UI

All expensive work is done in the background so there is no lockup in the main thread while data is being downloaded/displayed.

## Bonus

The app uses MVVM in order to handle all of the business logic that is not related to UI.  Anything that has to do with downloading data, configuring models, or  similar actions are handled by the ViewModels.  Anything that requires knowledge of UIKit is handled by the respective views.

## Extras 

I also implemented Pagination into the app, so you can infinitely scroll and download new users when you reach the end of the list.  I figured this would be a fun feature to implement and I wanted something unique to further demonstrate my skills. **NOTE: Please be careful about scrolling too fast as you may overload the requests to StackOverflow.  This results in a 10 hour timeout if this happens.**

## Closing thoughts

I had a great time with this project and hope you enjoyed looking at my submission.  If you have any questions please feel free to email me.  I'm looking forward to hearing from you!
