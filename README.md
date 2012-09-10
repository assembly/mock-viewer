# Assembly MockViewer for the iPhone

Do you hate uploading mockups to your phone and viewing them squished in the Photos app because they're not proportionately 320x480?

Do you hate not having an easy way to share those same mocks with others?

The Assembly MockViewer has your covered.

## Prerequisites

* Xcode to install the MockViewer on your iOS device
* Nginx running somewhere on the net to host your mockup images

## Install

1. Setup Nginx to host your mockups by placing something like the following your in your nginx.conf.

    server {
      listen 80;
      server_name yourwebsite.com;
    
      location /mocks {
        root   /data/yourwebsite-mocks/;
        index  index.html index.htm;
    
        # MockViewer looks for the files listed by autoindex
        autoindex on;
    
        ## Uncomment these lines to password protect the mocks
        ## Password setup info here: http://wiki.nginx.org/HttpAuthBasicModule
        # auth_basic "Restricted";
        # auth_basic_user_file httpaccess;
      }
    }

2. Open MockViewer/MockViewer.xcodeproj with Xcode, alter Config.h to point to you Nginx server and use authentication if desired.

3. Run MockView on your iOS device and enjoy!

## Usage

After uploading your images to the server they will automatically be indexed and listed in the MockViewer app.

Images matching a width of 320px or 640px will be displayed in portrait orientation.

Images matching a width of 480px or 960px will be displayed in landscape orientation.

You'll be able to scroll up and down on any of the images using their natural orientation.

When you're done viewing a mockup, long-press on it to return to the list of images.
