
### About
![IOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

Movie box mobile app

Functionalities in the app:

1. **List horizontally currently playing movies**

2. **Display the most popular movies in the vertical list view, with multiple pages**
	* Paging mechanism to load a list of movies as the user scrolls down the list.
	* Cache movie images, in order to make smooth scrolling.
	* Rating View.

3. **When a user clicks on any movie list item, it will navigate to a detailed screen, with more information about the movie**

#### Architecture
`MVVM` approach with the `coordinators` and `Combine` for binding.

Dependency free -> All dependencies are injected so we can have an easily testable code

#### Navigation structure
Coordinator handle all the logic for presentation between View Controllers and provides an encapsulations of navigation logic.

#### Theming

Protocols:
`ThemeContract`
`AppColors`
`AppFonts`

`ThemeSettings` applying application theam and appearance.

`DefaultTheme, DefaultColor, DefaultFonts` are classes which complies to the protocols and current theme.

#### Image Caching

Image caching done in the app with `URLCache`

Benefits over custom implementation
- Some items are automatically removed from the NSCache if memory is low. You don’t need to handle this logic yourself.
- NSCache is thread-safe, meaning that you should not fear race conditions when accessing it from multiple threads.
- We can specify the desired maximum size (in bytes) of the cache


`No 3rd party libraries`

`Supported OS iOS 14+`
