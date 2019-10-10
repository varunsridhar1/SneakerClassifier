# File Navigation Information

If you made it this far you're a real G

Main.storyboard shows the UI view so you can play around with that and make things look nice and add colors, etc.

LaunchScreen.storyboard is currently just our launcher and displays "N S I", pretty intuitive to play around with that.

ViewController.swift is our main class, handles setting up capture session, displaying the camera view, accepting a taken image, and handing inputs to our capture button

PhotoViewController.swift is a side class that presents the captured photo. We can possibly add references to our trained model here cuz it directly accepts the image. Otherwise I marked the spot we access the image in ViewController.swift too.
