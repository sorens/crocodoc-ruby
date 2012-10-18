# crocodoc-ruby

## Introduction

crocodoc-ruby is a Ruby wrapper for the Crocodoc API.
The Crocodoc API lets you upload documents and then generate secure and customized viewing sessions for them.
Our API is based on REST principles and generally returns JSON encoded responses,
and in Ruby are converted to hashes unless otherwise noted.

## Installation

We suggest installing the library as a gem.

    gem install --source http://gems.github.com crocodoc-crocodoc-ruby

You can also add the library as a submodule in your git project.

    git submodule add git@github.com:crocodoc/crocodoc-ruby.git

You can also get the library by cloning or downloading.

To clone:

    git clone git@github.com:crocodoc/crocodoc-ruby.git
    
To download:

    wget https://github.com/crocodoc/crocodoc-ruby/zipball/master -O crocodoc-ruby.zip
    unzip crocodoc-ruby.zip
    mv crocodoc-crocodoc-ruby-* crocodoc-ruby

Require the library into any of your Ruby files.

If you have the gem installed:

    require 'crocodoc'
    
If you have the files locally:

    require_relative /path/to/crocodoc-ruby/crocodoc.rb
    
## Getting Started

You can see a number of examples on how to use this library in examples.rb.
These examples are interactive and you can run this file to see crocodoc-ruby in action.

To run these examples, open up examples.rb and change this line to show your API token:

    Crocodoc.api_token = 'YOUR_API_TOKEN'
    
Save the file, make sure the example-files directory is writeable, and then run examples.rb:

    ruby examples.rb
    
You should see 15 examples run with output in your terminal.
You can inspect the examples.rb code to see each API call being used.

To start using crocodoc-ruby in your code, set your API token:

    Crocodoc.api_token = 'YOUR_API_TOKEN'
    
And now you can start using the methods in Crocodoc::Document, Crocodoc::Download, and Crocodoc::Session.

Read on to find out more how to use crocodoc-ruby.
You can also find more detailed information about our API here:
https://crocodoc.com/docs/api/

## Using the Crocodoc API Library

### Errors

Errors are handled by throwing exceptions.
We throw instances of CrocodocError.

Note that any Crocodoc API call can throw an exception.
When making API calls, put them in a begin/rescue block.
You can see examples.rb to see working code for each method using begin/rescue blocks.

### Document

These methods allow you to upload, check the status of, and delete documents.

#### Upload

https://crocodoc.com/docs/api/#doc-upload  
To upload a document, use Crocodoc::Document.upload().
Pass in a url (as a string) or a file resource object.
This function returns a UUID of the file.

    // with a url
    uuid = Crocodoc::Document.upload(url)
    
    // with a file
    file_handle = File.open(file_path, 'r')
    uuid = Crocodoc::Document.upload(file_handle)
    
#### Status

https://crocodoc.com/docs/api/#doc-status  
To check the status of one or more documents, use Crocodoc::Document.status().
Pass in the UUID of the file or an array of UUIDS you want to check the status of.
This function returns a hash containing a "status" string" and a "viewable" boolean.
If you passed in an array instead of a string, this function returns an array of hashes containing the status for each file.

    // $status contains status['status'] and status['viewable']
    status = Crocodoc::Document.status(uuid)
    
    // statuses contains an array of status hashes
    statuses = Crocodoc::Document.status([uuid, uuid2])
    
#### Delete

https://crocodoc.com/docs/api/#doc-delete  
To delete a document, use Crocodoc::Document.delete().
Pass in the UUID of the file you want to delete.
This function returns a boolean of whether the document was successfully deleted or not.

    deleted  = Crocodoc::Document.delete(uuid)
    
### Download

These methods allow you to download documents from Crocodoc in different ways.
You can download originals, PDFs, extracted text, and thumbnails.

#### Document

https://crocodoc.com/docs/api/#dl-doc  
To download a document, use Crocodoc::Download.document().
Pass in the uuid,
an optional boolean of whether or not the file should be downloaded as a PDF,
an optional boolean or whether or not the file should be annotated,
and an optional filter string.
This function returns the file contents as a string, which you probably want to save to a file.

    // with no optional arguments
    file = Crocodoc::Download.document(uuid)
    file_handle.write(file)
    
    // with all optional arguments
    file = Crocodoc::Download.document(uuid, true, true, 'all')
    file_handle.write(file)
    
#### Thumbnail

https://crocodoc.com/docs/api/#dl-thumb  
To download a thumbnail, use Crocodoc::Download.thumbnail().
Pass in the uuid and optionally the width and height.
This function returns the file contents as a string, which you probably want to save to a file.

    // with no optional size arguments
    thumbnail = Crocodoc::Download.thumbnail(uuid)
    file_handle.write(thumbnail)
    
    // with optional size arguments (width 77, height 100)
    thumbnail = Crocodoc::Download.thumbnail(uuid, 77, 100)
    file_handle.write(thumbnail)

#### Text

https://crocodoc.com/docs/api/#dl-text  
To download extracted text from a document, use Crocodoc::Download.text().
Pass in the uuid.
This function returns the extracted text as a string.

    text = Crocodoc::Download.text(uuid)
    
### Session

The session method allows you to create a session for viewing documents in a secure manner.

#### Create

https://crocodoc.com/docs/api/#session-create  
To get a session key, use Crocodoc::Session.create().
Pass in the uuid and optionally a params hash.
The params hash can contain an "is_editable" boolean,
a "user" hash with "id" and "name" fields,
a "filter" string, a "sidebar" string,
and booleans for "is_admin", "is_downloadable", "is_copyprotected", and "is_demo".
This function returns a session key.

    // without optional params
    session_key = Crocodoc::Session.create(uuid)
    
    // with optional params
    session_key = Crocodoc::Session.create(uuid, {
        'is_editable' => true,
        'user' => {
            'id' => 1,
            'name' => 'John Crocodile'
        },
        'filter' => 'all',
        'is_admin' => true,
        'is_downloadable' => true,
        'is_copyprotected' => false,
        'is_demo' => false,
        'sidebar' => 'visible'
    ))
    
## Support

Please use github's issue tracker for API library support.