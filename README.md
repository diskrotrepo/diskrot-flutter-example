## diskrot-flutter-example

The goal of this project is to provide a bare minimum example of how to build an application that can communicate with the diskrot platform. This example assumes you have already registered your application with https://developer.diskrot.com. You are more than welcome
to fork, port, whatever this application.

The project is preconfigured to talk to the real diskrot authentication provider. That way you only need to worry about working on your local application.

## PreReq

- Flutter 3.35.1
- Chrome 

## Running the Project

This command should be run from the packages/sample directory. It will launch the project in debug mode in Chrome on port 8090

```bash
flutter run -d chrome --web-port 8090
```

Press `r` to perform a hot reload while developing your application.


## Working with the sample app

In theory you should only need to stylize the `login/login_screen.dart` to your liking. You shouldn't need to touch the other files in the `login` directory.

## Bucket Setup

Flutter is configured to follow the URL, so if you're using Google Cloud Storage you'll need to run the following command to ensure the bucket is routing requests to the index.html:

```bash
gsutil web set -m index.html -e index.html gs://demo.diskrot.com
```

## Configuration

After registering your project with the network you will need to update the `lib/configuration/configuration.dart` file. 

**applicationId**
The `applicationId` is not a secert, and can be checked into your repo. Unless you're working with a local version of the platform, the
values of `applicationId` will be the same. The value uniquely identifies your application to diskrot. 

**redirectUri**

The `redirectUri` must match the redirectUri you registered with the diskrot developer app. During the authentication flow this value will be passed to the login application, and verified against the expected value. Provided there is a match, post login user's will be automatically be redirected back to the redirectUri to complete the authentication process.

```dart
    applicationId: switch (env) {
        BuildEnvironment.local => '1ce7757e-3c3a-42a9-8fa7-ec6923166b1b',
        BuildEnvironment.prod => '1ce7757e-3c3a-42a9-8fa7-ec6923166b1b',
      },
      redirectUri: switch (env) {
        BuildEnvironment.local => 'http://localhost:8090/oauth/callback',
        BuildEnvironment.prod => 'https://demo.diskrot.com/oauth/callback',
      },
```

## CI/CD

There is an example Github workflow file with `.github/workflows`. This will allow your application to be deployed to GCP provided you have a GCP account. 

**Configuration**

In order for this to work for your project you will need to update a few values. If you rename the project from `sample` to anything else (you should), then you'll want to update all references to `sample` to match your new directory name. The project assumes you will be deploying to Google Cloud Storage (GCS), and so you will want to change `demo.diskrot.com` to match the name of your bucket.

**Secrets**

You will need to create the following repository secrets

- GCP_SA_KEY:  A service account
- GCP_PROJECT_ID: The name of your GCP project

## To Do

# Backend Example

For now this project is focused on a simple Single Page Application (SPA). This project will be updated to show how to do a more complex project using a backend, and a diskrot API key. Do not check your API key into your repo as this is a secret.