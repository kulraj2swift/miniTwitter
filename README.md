# miniTwitter

How to run:
1) Take clone from github
2) do pod install
3) add the file ApiKeys.swift to your project. This contains the consumer client secret and client api key. This file is added to gitignore so its not on github which is public. I did not want to make my api key and secret public on github.
4) should be able to run now. In case the app relaunch takes too long just quit the simulator and run again

Functionality:
1) home screen: login or sign up with twitter account. Both the flows are same. on login we get the access token and secret associated with the logged in account which is saved to keychain. pagination is there and posts in one page are 5. pull to refresh is also there.
2) feed screen: first we fetch the logged in user id and then fetch his posts which are displayed. there is a logout and + button for creating new post
3) create new post screen: user can post tweet to twitter consisting of either a text or image, or both.

Libraries used:
1) OAuth
2) Swifter (not through cocoapods, but hard coded third party)
3) keychain wrapper

Known issues:
1) aka hana (red flower) image not picked by PHPicker on simulator. its a known apple issue.
