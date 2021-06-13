# ARIndoorNav - Indoor_Navigation-Based-AR App (IOS)

## Overview
This application was created as proof of concept to utilize ARKit in order to successfully navigate a person from point A to point B with onscreen markers.

Created by - Bryan Ung & Allie Do

#### Contacts - bryanung18@gmail.com

## Copyright
Copyright © 2021 bryan ung

## Setup
Open Project through .xcworkspace
#### SETUP PODS
    Pods Used: 'Firebase/Core'  'Firebase/Database'  'Firebase/Auth'
            1. Make sure you have cocapods installed on your Mac (https://guides.cocoapods.org/using/getting-started.html)
            2. Run "pod init" in your directory
            3. Run "pod install" in your directory 
        
#### POD ERROR TROUBLESHOOTING

        1. "pod deintegrate"
        2. "pod clean"
        3. "pod install"

#### SETUP FIREBASE DATABASE
    Notes/Links: 
        1. https://firebase.google.com/docs/auth/ios/start
        2. https://firebase.google.com/docs/ios/setup
        
    1. Login and create a firebase account and a realtime database.
    2. Inside console.firebase.google.com
        > Select Real Time Database
        > Create Realtime database
        > REMEMBER UR DATABASE NAME - You need it for setting up the NodeJS server
        > You can import /resources/ARIndoorNav-database-export.json into the DB
    3. Once your database is initialized, link your app to Firebase highlighted in Link 2
        1. Navigate to Project Settings > Under Your Apps > Click IOS App
        2. Fill in the information correctly, make sure the iOS bundle ID is correct
        3. Bundle id is defaulted to "com.bryanung". You can change this inside xcode
            3.3.1. Inside XCode, select the project > targets
            3.3.2. Look at the identity tag, change bundle identifier if you want (Check Images folder for reference)
    4. Move the GoogleService-Info.plist into root of XCode as highlighted in the link above. 
    
#### SETUP AUTH ACCESS

    Inside console.firebase.google.com
    > Click on Authentication
    > Enable Email/Password sign-in provider
    Note: The default Authentication the app uses for users is email/password

#### SETUP NODEJS SERVER

    Note: 
    1. https://firebase.google.com/docs/web/setup#node.js-apps
    2. https://firebase.google.com/docs/admin/setup

    1. Highlighted in Link 2
        1.1 To generate a private key file for your service account:
            > In the Firebase console, open Settings > Service Accounts.
            > Click Generate New Private Key, then confirm by clicking Generate Key.
            > Securely store/download the JSON file containing the key.
    2. Rename the downloaded key into "serviceAccountKey.json"
    3. Move serviceAccountKey.json to /server folder
    4. "npm install" the list below.
        > express
        > firebase-admin
        > request
    5. Inside ARIndoorNav/server/database.js
        - Replace 'databaseURL: "arindoornav-56dc2"' with the correct link ''https://<DATABASE_NAME>.firebaseio.com'' putting your database name in.
        
#### TO RUN APP

    1. Inside ARIndoorNav/server/ open up a console and run "node server.js" . Server is hosted on localhost:8080 (can be modified in the server file)
    2. Start Running app through simulator or connected device through .xcworkspace
    3. Need to link your server's IP address and the app's api links
        > Retrieve and save MAC Ip.Adress somewhere
        > Inside "ARIndoorNav.xcworkspace" > ARIndoorNav > Utils > Constants.swift
            > Replace IP adress underneath URLConstants with that of MAC Address
    
#### Notes
###### Check out the resources folder for importable database JSON for Firebase (You can import the file into Firebase)
###### App only keeps track of 1 image marker, further implementation has not been completed.
