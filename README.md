Estuary
=======

Stream data from a list of social-media accounts.

## What it does

Estuary is web server software which takes a list of social-media accounts (from a [social media registry](https://github.com/usagov/ringsail), for example)  and compiles a stream of updates posted to those accounts.

For example, the city of Springfield might have a list of all its Twitter, Facebook, Flickr, and Youtube accounts in a social media registry. They could use Estuary to combine the output of all those accounts into a single stream and display the results on the official springfield.gov website.

Estuary emits the stream of social-media updates via an API, which can be queried and filtered interactively. For example, the Springfield stream from above could be filtered to only include the Flickr photos and Youtube videos that are tagged 'parks', for use on a Parks and Recreation page. 

## Quick Start

## How it works

Estuary is server software written in Ruby on Rails, designed to be deployed to cloud infrastructure like Heroku or Amazon Web Services. An application server handles incoming API requests, and worker servers collect data from social-media APIs and store an index of all the posts.

Estuary combines public APIs (a registry and multiple social media services) to produce an API of its own. That API is designed to be consumed directly by web sites, mobile applications, and other public-facing widgets. 

Stream data is segmented by date, which allows recent items to be accessed and composited quickly while also providing deep archives for longitudinal research.

The API returns data from all social media services in the same format, with the minimum information necessary to preview the post and link to the complete post. Records for a Youtube video, a Flickr photo, and a Tweet all have the same fields, and other services can be added into the same framework. Records are collated (usually by date) into a single, consistent stream.

The Estuary back end is designed to be as kind to source APIs as possible. The social-media APIs are used sparingly and infrequently, with a strong emphasis on obeying rate limits. The registry APIs are also accessed infrequently, because they're not likely to change rapidly.

The front-end API, on the other hand, is designed to accept frequent and intermittent requests for data and respond quickly. It should be able to handle direct access from a website widget, for instance, without the need for special caching or rate limiting.

## Installation

### On Heroku

### In an existing Rails environment

## Caveats

An Estuary server will produce enormous amounts of data. It's basically an index of every post produced by whatever list of social-media accounts you provide.

Estuary is designed to combine public data sources to produce another public data source. Aside from the keys for accessing social media and registry APIs, data is not stored securely or hidden behind access controls. 

Estuary doesn't access social media APIs in real time, so the stream data is always at least a few hours old. Posts might not appear for a day or more after adding an account to a source registry.

The data store isn't a complete archive of all posts. It trades 100% coverage for better performance and API friendliness. Use an archiving service or download from the social-media service itself if a complete archive is needed.


## Contact

Estuary is a Measured Voice project. We're developing it to help government social-media writers.

Questions? Love this software? Email us at hi@measuredvoice.com.
